import boto3
import logging
from botocore.exceptions import ClientError
import json
import base64
import ast

# Instantiate logger
logger = logging.getLogger(__name__)

# connect to the Rekognition client
rekognition = boto3.client('rekognition')

def lambda_handler(event, context):
    try:
      s3 = boto3.client('s3')

      # Extracting S3 values
      s3_objects = extract_s3_values(event)

      # Initializing Rekognition client
      rekognition = boto3.client('rekognition')

      # List to hold response of rekognition.detect_labels
      rekognition_responses = []

      for s3_obj in s3_objects:
        s3_object = s3.get_object(Bucket = s3_obj['s3bucketname'], Key = s3_obj['objectname'])
        print(s3_object)
        image = s3_object['Body'].read()

        # Perform label detection
        #response = rekognition.detect_labels(Image={'Bytes': image})
        response = rekognition.detect_labels(Image = {"S3Object": {"Bucket":  s3_obj['s3bucketname'], "Name": s3_obj['objectname']}}, MaxLabels=3,  MinConfidence=70)
        print(response)
        rekognition_responses.append(response)


        labels = [label['Name'] for label in response['Labels']]
        print(f"Labels found for {s3_obj['objectname']} :")
        print(labels)

      lambda_response = {
      "statusCode": 200,
      "body": json.dumps(rekognition_responses)
    }


    except ClientError as client_err:
      error_message = "Couldn't analyze image: " + client_err.response['Error']['Message']

      lambda_response = {
            'statusCode': 400,
            'body': {
                "Error": client_err.response['Error']['Code'],
                                                                  "ErrorMessage": error_message
                                                                }
    }
      logger.error("Error function %s: %s", context.invoked_function_arn, error_message)

    except ValueError as val_error:
      lambda_response = {
      'statusCode': 400,
      'body': {
        "Error": "ValueError",
        "ErrorMessage": format(val_error)
      }
    }
      logger.error("Error function %s: %s", context.invoked_function_arn, format(val_error))


def extract_s3_values(json_data):
    msg = json_data['Records']
    res = []

    for item in msg:
      body = json.loads(item['body'])
      message = json.loads(body['Message'])
      message = ast.literal_eval(json.dumps(message))

      s3bucketname = message['Records'][0]['s3']['bucket']['name']
      object_name = message['Records'][0]['s3']['object']['key']

      res.append({
      's3bucketname': s3bucketname,
      'objectname': object_name
    })
      print(res)

    return res



