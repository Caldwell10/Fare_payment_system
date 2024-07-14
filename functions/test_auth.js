const axios = require('axios');

const mpesaCredentials = {
  consumerKey: 'ZY4WuVa1LXFz2QhAAwFffzl6GHhxNp70D5goRhdxMqoFg6OZ',
  consumerSecret: 'ZHa90s6bfzoG3cNGwld0JQeTad50HQN746VLWcwcbnV0gaMvDtah39GkeCmNgsVJ',
};

async function getMpesaAccessToken() {
  const url = 'https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials';
  const auth = Buffer.from(`${mpesaCredentials.consumerKey}:${mpesaCredentials.consumerSecret}`).toString('base64');

  try {
    console.log('Sending request to URL:', url);
    console.log('Authorization header:', `Basic ${auth}`);

    const response = await axios.get(url, {
      headers: {
        Authorization: `Basic ${auth}`,
      },
    });

    console.log('Response received');
    
    if (response.status === 200) {
      console.log('Access Token:', response.data.access_token);
    } else {
      console.error('Failed to obtain access token:', response.status, response.statusText, response.data);
    }
  } catch (error) {
    console.error('Error obtaining access token:', error.response ? error.response.data : error.message);
    console.error('Error details:', error);
  }
}

getMpesaAccessToken();
