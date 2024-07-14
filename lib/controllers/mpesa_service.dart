import 'dart:convert';
import 'package:http/http.dart' as http;

class MpesaService {
  static const String consumerKey = 'ZY4WuVa1LXFz2QhAAwFffzl6GHhxNp70D5goRhdxMqoFg6OZ';
  static const String consumerSecret = 'ZHa90s6bfzoG3cNGwld0JQeTad50HQN746VLWcwcbnV0gaMvDtah39GkeCmNgsVJ';
  static const String shortCode = '174379';
  static const String passKey = 'bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919';
  static const String authUrl = 'https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials';
  static const String stkPushUrl = 'https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest';

  Future<String> _getAccessToken() async {
    try {
      final String auth = 'Basic ' + base64Encode(utf8.encode('$consumerKey:$consumerSecret'));
      print('Authorization Header: $auth'); 
      final http.Response response = await http.get(Uri.parse(authUrl), headers: {'Authorization': auth});

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Access Token: ${data['access_token']}');  
        return data['access_token'];
      } else {
        throw Exception('Failed to load access token: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting access token: $e');
    }
  }

  Future<String> initiateStkPush(String phoneNumber, String amount, String accountReference, String transactionDesc) async {
    try {
      final String accessToken = await _getAccessToken();

      final DateTime now = DateTime.now().toUtc();
      final String timestamp = "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
      final String password = base64Encode(utf8.encode('$shortCode$passKey$timestamp'));
     

      final Map<String, dynamic> payload = {
        'BusinessShortCode': shortCode,
        'Password': password,
        'Timestamp': timestamp,
        'TransactionType': 'CustomerPayBillOnline',
        'Amount': amount,
        'PartyA': phoneNumber,
        'PartyB': shortCode,
        'PhoneNumber': phoneNumber,
        'CallBackURL': 'https://us-central1-fare-payment-system.cloudfunctions.net/mpesaCallback', // Replace with your callback URL
        'AccountReference': accountReference,
        'TransactionDesc': transactionDesc,
      };



      final http.Response response = await http.post(
        Uri.parse(stkPushUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        return 'Success';
      } else {
        throw Exception('Failed to initiate STK push: ${response.statusCode}, body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error initiating STK push: $e');
    }
  }
}
