import json
import boto3
from datetime import datetime
from dateutil import tz
import re
import logging
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)

now = datetime.now(tz=tz.tzlocal())

def getIAMUserList():
    client = boto3.client('iam')
    IAMdetails = client.list_users()
    userDetails = []
    for IAMdetail in IAMdetails['Users']:
        username = IAMdetail['UserName']
        userDetails.append(username)
    regex = re.compile("ses-smtp*")
    IAMUserLists = [i for i in userDetails if not regex.match(i)]
    logging.info("List of all non-ses user is: " + str(IAMUserLists ))
    return IAMUserLists

def deleteAccessKey(IAMUserLists):
    client = boto3.client('iam')
    oldAccessKeyUser = []
    for user in IAMUserLists:
        paginator = client.get_paginator('list_access_keys')
        for userJsonData in paginator.paginate(UserName=user):
            for akm in userJsonData['AccessKeyMetadata']:
                oldAccessKey = akm['AccessKeyId']
                if (now - akm['CreateDate']).days >= 90:
                    logging.info(oldAccessKey +' is older than 90 days')
                    oldAccessKeyUser.append(user)
#                    deleteAccessKey = client.delete_access_key(
#                        UserName=user,
#                        AccessKeyId=oldAccessKey
#                    )
#                    createNewAccessKey = client.create_access_key(UserName=user)
                else:
                    pass
    logging.info('List of user access key deleted are :' +str(oldAccessKeyUser))
    return oldAccessKeyUser

def notification(oldAccessKeyUser):
    if len(oldAccessKeyUser):
        client = boto3.client('sns')
        response = client.publish(
        TopicArn="{}".format(os.environ['snsTopicArn']),
        Message='Alert!!!!\nFollowing users access keys are older than 90 days: In the future they will be deleted\n' + str(oldAccessKeyUser),
        Subject='Access Key Rotation after 90 days'
        )
    else:
        pass

def lambda_handler(event,context):
    getUserList = getIAMUserList()
    rotateAccessKey = deleteAccessKey(getUserList)
    snsNotification = notification(rotateAccessKey)
