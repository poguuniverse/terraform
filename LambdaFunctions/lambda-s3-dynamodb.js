import { S3 } from '@aws-sdk/client-s3';
console.log('Loading function');
import { DynamoDB } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocument } from '@aws-sdk/lib-dynamodb';


const dynamoDB = DynamoDBDocument.from(new DynamoDB());
const s3 = new S3();

export const handler = async (event) => {
  try {
    console.log('Received event:', JSON.stringify(event));

    const contentType = event.headers['Content-Type'];
    const boundaryMatch = contentType.match(/boundary=(?:"([^"]+)"|([^;]+))/);
    const boundary = boundaryMatch ? (boundaryMatch[1] || boundaryMatch[2]) : null;

    if (!boundary) {
      console.error('Boundary not found in Content-Type header.');
      return {
        statusCode: 400,
        body: JSON.stringify({ message: 'Boundary not found in Content-Type header.' }),
      };
    }

    const encryptedBody = event.body; // Encrypted data in event.body
    // Decrypt the encryptedBody here using your decryption logic
    const decryptedBody = base64Decode(encryptedBody); // Replace with your decryption logic

    console.log('Decrypted body:', decryptedBody);

    const parts = decryptedBody.split(`--${boundary}`);

    if (parts.length < 2) {
      console.error('Invalid data format.');
      return {
        statusCode: 400,
        body: JSON.stringify({ message: 'Invalid data format.' }),
      };
    }

    const fileData = parts.find((part) => part.includes('filename='));

    if (!fileData) {
      console.error('File data not found in request.');
      return {
        statusCode: 400,
        body: JSON.stringify({ message: 'File data not found in request.' }),
      };
    }

    const fileNameMatch = fileData.match(/(?:filename=")(.*?)"/i);
    const fileName = fileNameMatch ? fileNameMatch[1] : 'file.txt'; // Default file name if not found

    const fileContent = fileData.split('\r\n\r\n')[1];

    console.log('File name:', fileName);

    const params = {
      Bucket: 'insurance-claims-app',
      Key: fileName,
      Body: Buffer.from(fileContent, 'binary'),
      ContentType: 'image/jpeg'
    };

    console.log('Uploading file to S3:', fileName);

    const uploadResult = await s3.putObject(params)

    console.log('Upload result:', uploadResult);

    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'File uploaded successfully', data: uploadResult }),
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
