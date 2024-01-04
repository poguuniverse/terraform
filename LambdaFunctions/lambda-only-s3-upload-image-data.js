import { S3 } from '@aws-sdk/client-s3';
import { DynamoDB } from '@aws-sdk/client-dynamodb';
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { PutCommand, DynamoDBDocumentClient } from "@aws-sdk/lib-dynamodb";

const dbClient = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(dbClient);

const s3 = new S3();

const handler = async (event) => {
    try {
        console.log('Received event:', JSON.stringify(event));
        const data = event.data
        var buffer = Buffer.from(data.replace(/^data:image\/\w+;base64,/, ""),'base64')
        const s3FileName = "claimInt.png";
        const params = {
            Bucket: 'insurance-claims-app',
            Key: s3FileName,
            Body: buffer,
            ContentType: 'image/png'
        };
        console.log('Uploading file to S3:', s3FileName);
        await s3.putObject(params);
        const claimId = generateRandomId();
        const dBcommand = new PutCommand({
            TableName: 'insurance-claim-app',
            Item: {
                claimID: claimId,
                imageUrl: s3FileName, // Assuming you want to store the S3 file name as imageUrl
                claimStatus: false // Adding claimStatus field set to false
                // Add other attributes as needed
            },
        });
        const response = await docClient.send(dBcommand);
        console.log(response);
        console.log('Claim ID:', claimId);
        return {
            statusCode: 200,
            body: JSON.stringify({message: 'File uploaded successfully', claimId}),
        };
    } catch (error) {
        console.error('Error uploading file:', error);

        return {
            statusCode: 500,
            body: JSON.stringify({ message: 'Error uploading file', error: error.message }),
        };
    }
};

const base64Decode = (encodedString) => {
    return Buffer.from(encodedString, 'base64').toString('utf-8');
};

const generateRandomId = () => {
    return Math.random().toString(36).substr(2, 9); // Example: Generates a random alphanumeric ID
};

export { handler };
