import 'package:flutter/material.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';



void main() => runApp(MaterialApp(
  home: InterestCalculatorApp(),
  debugShowCheckedModeBanner: false,
  theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
));

class InterestCalculatorApp extends StatefulWidget {
  @override
  _InterestCalculatorAppState createState() => _InterestCalculatorAppState();
}

class _InterestCalculatorAppState extends State<InterestCalculatorApp> {
  // Controller để lấy dữ liệu
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  void _showContactInfo() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Liên hệ với chúng tôi", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              ListTile(
                leading: CircleAvatar(backgroundColor: Colors.blue[100], child: Icon(Icons.phone, color: Colors.blue)),
                title: Text("Gọi điện thoại"),
                subtitle: Text("0944745991"),
                onTap: () => _launchURL('tel:0944745991'), // Tự động mở trình quay số
              ),
              ListTile(
                leading: CircleAvatar(backgroundColor: Colors.red[100], child: Icon(Icons.email, color: Colors.red)),
                title: Text("Gửi Email"),
                subtitle: Text("thanhvatli0311@gmail.com"),
                onTap: () => _launchURL('mailto:thanhvatli0311@gmail.com?subject=Hỗ trợ App Máy Tính Lãi Suất'), // Mở app Mail
              ),
              ListTile(
                leading: CircleAvatar(backgroundColor: Colors.green[100], child: Icon(Icons.location_on, color: Colors.green)),
                title: Text("Địa chỉ văn phòng"),
                subtitle: Text("Số 19, ngõ 39 Hồ Tung Mậu"),
                onTap: () => _launchURL('https://www.google.com/maps/search/?api=1&query=So+19+ngo+39+ho+tung+mau'), // Mở Google Maps
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Không thể mở liên kết: $urlString');
    }
  }
  Future<void> _openWebsite() async {
    const String urlString = 'https://github.com/thanhvatli0311/tinh_toan_lai_suat';
    final Uri url = Uri.parse(urlString);

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.inAppWebView,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
          ),
        );
      } else {
        throw 'Không thể mở $urlString';
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  void _showAboutApp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.orange),
              SizedBox(width: 10),
              Text("Về ứng dụng"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Để hộp thoại vừa khít nội dung
            children: [
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.calculate, size: 50, color: Colors.blue),
              ),
              SizedBox(height: 15),
              Text(
                "MÁY TÍNH LÃI SUẤT",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                "Ứng dụng hỗ trợ tính toán lãi suất cho bạn.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),
              Divider(height: 30),
              Text("Phiên bản: 1.0.1", style: TextStyle(fontSize: 12)),
              Text("Tác giả: Nguyễn Văn Tâm", style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          actions: [
            TextButton(
              child: Text("ĐÓNG"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  String _result = "";

  // Hàm tính toán logic
  void _calculate() {
    FocusScope.of(context).unfocus();

    double? principal = double.tryParse(_amountController.text.replaceAll(',', ''));
    double? ratePerYear = double.tryParse(_rateController.text);

    if (principal != null && ratePerYear != null && ratePerYear > 0) {
      double rateDecimal = ratePerYear / 100;
      double years = log(2) / log(1 + rateDecimal);

      setState(() {
        _result = "${years.toStringAsFixed(2)}";
      });
    } else {
      setState(() {
        _result = "Lỗi!";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập số tiền và lãi suất hợp lệ!'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Máy tính lãi suất", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      // Phần Menu
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              accountName: Text("Nguyễn Văn Tâm", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              accountEmail: Text("20223183@eaut.edu.vn"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.blue),
              ),
            ),
            ListTile(
              leading: Icon(Icons.info_outline, color: Colors.blue),
              title: Text('Giới thiệu App'),
              onTap: () {
                Navigator.pop(context);
                _showAboutApp();
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail_outlined, color: Colors.green),
              title: Text('Thông tin liên hệ'),
              onTap: () {
                Navigator.pop(context);
                _showContactInfo();
              },
            ),
            ListTile(
              leading: Icon(Icons.language, color: Colors.purple),
              title: Text('Truy cập Website'),
              subtitle: Text('Xem thêm hướng dẫn tại đây'),
              onTap: () {
                Navigator.pop(context);
                _openWebsite();
              },
            ),
            Divider(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Cụm Nhập liệu
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text("Nhập thông tin", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 15),
                    _buildInputField(
                      controller: _amountController,
                      label: "Số tiền gốc (VNĐ)",
                      icon: Icons.money,
                    ),
                    SizedBox(height: 15),
                    _buildInputField(
                      controller: _rateController,
                      label: "Lãi suất hàng năm (%)",
                      icon: Icons.percent,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 25),

            // Trang trí giao diện kết quả
            Card(
              color: Colors.blue[50],
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.blue[100]!)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text("Số năm để tiền tăng gấp đôi", style: TextStyle(color: Colors.blue[800])),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          _result.isEmpty ? "--" : _result,
                          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.blue[900]),
                        ),
                        SizedBox(width: 5),
                        Text("năm", style: TextStyle(color: Colors.blue[800], fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // Nút bấm
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _calculate,
                icon: Icon(Icons.calculate),
                label: Text("TÍNH TOÁN KẾT QUẢ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm helper để tạo Input Field đồng nhất
  Widget _buildInputField({required TextEditingController controller, required String label, required IconData icon}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), // Ô nhập có khung
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: TextInputType.number,
    );
  }
}