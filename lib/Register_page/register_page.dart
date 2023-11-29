import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jonk_lab/Home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

final LabDetails = GlobalKey<FormState>();
final  Address = GlobalKey<FormState>();
final  BankDetails = GlobalKey<FormState>();
List <GlobalKey<FormState>> FormKey=[LabDetails,Address,BankDetails];


class RegisterPage extends StatefulWidget {
  var number;

   RegisterPage({Key? key, required this.number}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  loginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('status', 'true');
    prefs.setString('UserId', auth!);
  }


 continueStep(){
    if(currentStep<4){
     if(currentStep<3) {
        if (FormKey[currentStep].currentState!.validate()){
          currentStep = currentStep + 1;
          setState(() {});
        }
      }

     else {
       currentStep = currentStep + 1;
     }
    }
    if(currentStep==4){
      RegisterData();
    }
  }
  cancleStep(){
    if(currentStep>0){
      currentStep = currentStep -1;
      setState(() {});
    }
  }
  onStepTapped(int value ){
   currentStep=value;
   setState(() {
   });
 }
  var currentStep=0;


  List province=['A','b','c','d','e','f','g','h'];
  List bankname=['Allahabad Bank', 'Andhra Bank', 'Axis Bank', 'Bank of Bahrain and Kuwait', 'Bank of Baroda', 'Bank of India', 'Bank of Maharashtra', 'Canara Bank', 'Central Bank of India', 'City Union Bank', 'Corporation Bank', 'Deutsche Bank', 'Development Credit Bank', 'Dhanlaxmi Bank', 'Federal Bank', 'ICICI Bank', 'IDBI Bank', 'Indian Bank', 'Indian Overseas Bank', 'IndusInd Bank', 'ING Vysya Bank', 'Jammu and Kashmir Bank', 'Karnataka Bank Ltd', 'Karur Vysya Bank', 'Kotak Bank', 'Laxmi Vilas Bank', 'Oriental Bank of Commerce', 'Punjab National Bank', 'Punjab & Sind Bank', 'Shamrao Vitthal Co-operative Bank', 'South Indian Bank', 'State Bank of Bikaner & Jaipur', 'State Bank of Hyderabad', 'State Bank of India', 'State Bank of Mysore', 'State Bank of Patiala', 'State Bank of Travancore', 'Syndicate Bank', 'Tamilnad Mercantile Bank Ltd.', 'UCO Bank', 'Union Bank of India', 'United Bank of India', 'Vijaya Bank', 'Yes Bank Ltd',];
   Map<String,List<String>> StateDistric= {
      "State":['Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh',
        'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand', 'Karnataka',
        'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur', 'Meghalaya', 'Mizoram',
        'Nagaland', 'Odisha', 'Punjab', 'Rajasthan', 'Sikkim', 'Tamil Nadu', 'Telangana',
        'Tripura', 'Uttar Pradesh', 'Uttarakhand', 'West Bengal','Andaman and Nicobar Islands',
        'Chandigarh', 'Dadra and Nagar Haveli and Daman and Diu', 'Lakshadweep', 'Delhi',
        'Puducherry', 'Ladakh', 'Lakshadweep'],

      'Andhra Pradesh': ['Anantapur', 'Chittoor', 'East Godavari', 'Guntur', 'Krishna', 'Kurnool', 'Nellore', 'Prakasam', 'Srikakulam', 'Visakhapatnam', 'Vizianagaram', 'West Godavari', 'Y.S.R. Kadapa (Cuddapah)'],
      'Arunachal Pradesh': ['Tawang', 'West Kameng', 'East Kameng', 'Papum Pare', 'Kurung Kumey', 'Kra Daadi', 'Lower Subansiri', 'Upper Subansiri', 'West Siang', 'East Siang', 'Siang', 'Upper Siang', 'Lower Siang', 'Lower Dibang Valley', 'Dibang Valley', 'Anjaw', 'Lohit', 'Namsai', 'Changlang', 'Tirap', 'Longding'],
      'Assam': ['Baksa', 'Barpeta', 'Biswanath', 'Bongaigaon', 'Cachar', 'Charaideo', 'Chirang', 'Darrang', 'Dhemaji', 'Dhubri', 'Dibrugarh', 'Dima Hasao', 'Goalpara', 'Golaghat', 'Hailakandi', 'Hojai', 'Jorhat', 'Kamrup', 'Kamrup Metropolitan', 'Karbi Anglong', 'Karimganj', 'Kokrajhar', 'Lakhimpur', 'Majuli', 'Morigaon', 'Nagaon', 'Nalbari', 'Sivasagar', 'Sonitpur', 'South Salmara-Mankachar', 'Tinsukia', 'Udalguri'],
      'Bihar': ['Araria', 'Arwal', 'Aurangabad', 'Banka', 'Begusarai', 'Bhagalpur', 'Bhojpur', 'Buxar', 'Darbhanga', 'East Champaran', 'Gaya', 'Gopalganj', 'Jamui', 'Jehanabad', 'Kaimur', 'Katihar', 'Khagaria', 'Kishanganj', 'Lakhisarai', 'Madhepura', 'Madhubani', 'Munger', 'Muzaffarpur', 'Nalanda', 'Nawada', 'Patna', 'Purnia', 'Rohtas', 'Saharsa', 'Samastipur', 'Saran', 'Sheikhpura', 'Sheohar', 'Sitamarhi', 'Siwan', 'Supaul', 'Vaishali', 'West Champaran'],
      'Chhattisgarh': ['Balod', 'Baloda Bazar', 'Balrampur', 'Bastar', 'Bemetara', 'Bijapur', 'Bilaspur', 'Dantewada', 'Dhamtari', 'Durg', 'Gariaband', 'Janjgir-Champa', 'Jashpur', 'Kabirdham (Kawardha)', 'Kanker', 'Kondagaon', 'Korba', 'Koriya', 'Mahasamund', 'Mungeli', 'Narayanpur', 'Raigarh', 'Raipur', 'Rajnandgaon', 'Sukma', 'Surajpur', 'Surguja'],
      'Goa': ['North Goa', 'South Goa'],
      'Gujarat': ['Ahmedabad', 'Amreli', 'Anand', 'Aravalli', 'Banaskantha', 'Bharuch', 'Bhavnagar', 'Botad', 'Chhota Udaipur', 'Dahod', 'Dang', 'Devbhoomi Dwarka', 'Gandhinagar', 'Gir Somnath', 'Jamnagar', 'Junagadh', 'Kheda', 'Kutch', 'Mahisagar', 'Mehsana', 'Morbi', 'Narmada', 'Navsari', 'Panchmahal', 'Patan', 'Porbandar', 'Rajkot', 'Sabarkantha', 'Surat', 'Surendranagar', 'Tapi', 'Valsad',],
      'Haryana': ['Ambala', 'Bhiwani', 'Charkhi Dadri', 'Faridabad', 'Fatehabad', 'Gurugram', 'Hisar', 'Jhajjar', 'Jind', 'Kaithal', 'Karnal', 'Kurukshetra', 'Mahendragarh', 'Nuh', 'Palwal', 'Panchkula', 'Panipat', 'Rewari', 'Rohtak', 'Sirsa', 'Yamunanagar'],
      'Himachal Pradesh': [  'Bilaspur', 'Chamba', 'Hamirpur', 'Kangra', 'Kinnaur', 'Kullu', 'Lahaul and Spiti', 'Mandi', 'Shimla', 'Sirmaur', 'Solan', 'Una'],
      'Jharkhand': ['Bokaro', 'Chatra', 'Deoghar', 'Dhanbad', 'Dumka', 'East Singhbhum', 'Garhwa', 'Giridih', 'Godda', 'Gumla', 'Hazaribagh', 'Jamtara', 'Khunti', 'Koderma', 'Latehar', 'Lohardaga', 'Pakur', 'Palamu', 'Ramgarh', 'Ranchi', 'Sahebganj', 'Seraikela-Kharsawan', 'Simdega', 'West Singhbhum'],
      'Karnataka': ['Bagalkot', 'Ballari (Bellary)', 'Belagavi (Belgaum)', 'Bengaluru Rural', 'Bengaluru Urban', 'Bidar', 'Chamarajanagar', 'Chikballapur', 'Chikkamagaluru', 'Chitradurga', 'Dakshina Kannada', 'Davanagere', 'Dharwad', 'Gadag', 'Hassan', 'Haveri', 'Kalaburagi (Gulbarga)', 'Kodagu', 'Kolar', 'Koppal', 'Mandya', 'Mysuru (Mysore)', 'Raichur', 'Ramanagara', 'Shivamogga (Shimoga)', 'Tumakuru (Tumkur)', 'Udupi', 'Uttara Kannada', 'Vijayapura (Bijapur)', 'Yadgir'],
      'Kerala': [ 'Alappuzha', 'Ernakulam', 'Idukki', 'Kannur', 'Kasaragod', 'Kollam', 'Kottayam', 'Kozhikode', 'Malappuram', 'Palakkad', 'Pathanamthitta', 'Thiruvananthapuram', 'Thrissur', 'Wayanad'],
      'Madhya Pradesh': [ 'Agar Malwa', 'Alirajpur', 'Anuppur', 'Ashoknagar', 'Balaghat', 'Barwani', 'Betul', 'Bhind', 'Bhopal', 'Burhanpur', 'Chhatarpur', 'Chhindwara', 'Damoh', 'Datia', 'Dewas', 'Dhar', 'Dindori', 'Guna', 'Gwalior', 'Harda', 'Hoshangabad', 'Indore', 'Jabalpur', 'Jhabua', 'Katni', 'Khandwa', 'Khargone', 'Mandla', 'Mandsaur', 'Morena', 'Narsinghpur', 'Neemuch', 'Panna', 'Raisen', 'Rajgarh', 'Ratlam', 'Rewa', 'Sagar', 'Satna', 'Sehore', 'Seoni', 'Shahdol', 'Shajapur', 'Sheopur', 'Shivpuri', 'Sidhi', 'Singrauli', 'Tikamgarh', 'Ujjain', 'Umaria', 'Vidisha'],
      'Maharashtra': ['Ahmednagar', 'Akola', 'Amravati', 'Aurangabad', 'Beed', 'Bhandara', 'Buldhana', 'Chandrapur', 'Dhule', 'Gadchiroli', 'Gondia', 'Hingoli', 'Jalgaon', 'Jalna', 'Kolhapur', 'Latur', 'Mumbai City', 'Mumbai Suburban', 'Nagpur', 'Nanded', 'Nandurbar', 'Nashik', 'Osmanabad', 'Palghar', 'Parbhani', 'Pune', 'Raigad', 'Ratnagiri', 'Sangli', 'Satara', 'Sindhudurg', 'Solapur', 'Thane', 'Wardha', 'Washim', 'Yavatmal'],
      'Manipur': [ 'Bishnupur', 'Chandel', 'Churachandpur', 'Imphal East', 'Imphal West', 'Jiribam', 'Kakching', 'Kamjong', 'Kangpokpi', 'Noney', 'Pherzawl', 'Senapati', 'Tamenglong', 'Tengnoupal', 'Thoubal', 'Ukhrul',],
      'Meghalaya': [ 'East Garo Hills', 'East Jaintia Hills', 'East Khasi Hills', 'North Garo Hills', 'Ri-Bhoi', 'South Garo Hills', 'South West Garo Hills', 'South West Khasi Hills', 'West Garo Hills', 'West Jaintia Hills', 'West Khasi Hills'],
      'Mizoram': [ 'Aizawl', 'Lunglei', 'Saiha', 'Champhai', 'Serchhip', 'Kolasib', 'Lawngtlai', 'Mamit', 'Hnahthial', 'Khawzawl', 'Saitual',],
      'Nagaland': [  'Dimapur', 'Kohima', 'Mokokchung', 'Mon', 'Peren', 'Phek', 'Tuensang', 'Wokha', 'Zunheboto'],
      'Odisha': ['Angul', 'Balangir', 'Balasore', 'Bargarh', 'Bhadrak', 'Cuttack', 'Deogarh', 'Dhenkanal', 'Gajapati', 'Ganjam', 'Jagatsinghpur', 'Jajpur', 'Jharsuguda', 'Kalahandi', 'Kandhamal', 'Kendrapara', 'Kendujhar (Keonjhar)', 'Khurda', 'Koraput', 'Malkangiri', 'Mayurbhanj', 'Nabarangpur', 'Nayagarh', 'Nuapada', 'Puri', 'Rayagada', 'Sambalpur', 'Subarnapur (Sonepur)', 'Sundargarh'],
      'Punjab': ['Amritsar', 'Barnala', 'Bathinda', 'Faridkot', 'Fatehgarh Sahib', 'Fazilka', 'Ferozepur', 'Gurdaspur', 'Hoshiarpur', 'Jalandhar', 'Kapurthala', 'Ludhiana', 'Mansa', 'Moga', 'Muktsar', 'Pathankot', 'Patiala', 'Rupnagar', 'Sangrur', 'S.A.S. Nagar (Mohali)', 'Tarn Taran'],
       'Rajasthan': ['Ajmer', 'Alwar', 'Banswara', 'Baran', 'Barmer', 'Bharatpur', 'Bhilwara', 'Bikaner', 'Bundi', 'Chittorgarh', 'Churu', 'Dausa', 'Dholpur', 'Dungarpur', 'Hanumangarh', 'Jaipur', 'Jaisalmer', 'Jalore', 'Jhalawar', 'Jhunjhunu', 'Jodhpur', 'Karauli', 'Kota', 'Nagaur', 'Pali', 'Pratapgarh', 'Rajsamand', 'Sawai Madhopur', 'Sikar', 'Sirohi', 'Sri Ganganagar', 'Tonk', 'Udaipur'],
       'Sikkim': ['East Sikkim', 'North Sikkim', 'South Sikkim', 'West Sikkim'],
       'Tamil Nadu': ['Ariyalur', 'Chengalpattu', 'Chennai', 'Coimbatore', 'Cuddalore', 'Dharmapuri', 'Dindigul', 'Erode', 'Kallakurichi', 'Kanchipuram', 'Kanyakumari', 'Karur', 'Krishnagiri', 'Madurai', 'Mayiladuthurai', 'Nagapattinam', 'Namakkal', 'Nilgiris', 'Perambalur', 'Pudukkottai', 'Ramanathapuram', 'Ranipet', 'Salem', 'Sivaganga', 'Tenkasi', 'Thanjavur', 'Theni', 'Thoothukudi', 'Tiruchirappalli', 'Tirunelveli', 'Tirupathur', 'Tiruppur', 'Tiruvallur', 'Tiruvannamalai', 'Tiruvarur', 'Vellore', 'Viluppuram', 'Virudhunagar'],
       'Telangana': ['Adilabad', 'Bhadradri Kothagudem', 'Hyderabad', 'Jagtial', 'Jangaon', 'Jayashankar Bhupalpally', 'Jogulamba Gadwal', 'Kamareddy', 'Karimnagar', 'Khammam', 'Komaram Bheem', 'Mahabubabad', 'Mahabubnagar', 'Mancherial', 'Medak', 'Medchal-Malkajgiri', 'Nagarkurnool', 'Nalgonda', 'Nirmal', 'Nizamabad', 'Peddapalli', 'Rajanna Sircilla', 'Ranga Reddy', 'Sangareddy', 'Siddipet', 'Suryapet', 'Vikarabad', 'Wanaparthy', 'Warangal Rural', 'Warangal Urban', 'Yadadri Bhuvanagiri'],
       'Tripura': [  'Dhalai', 'Gomati', 'Khowai', 'North Tripura', 'Sepahijala', 'South Tripura', 'Unakoti', 'West Tripura'],
       'Uttar Pradesh': ['Agra', 'Aligarh', 'Allahabad', 'Ambedkar Nagar', 'Amethi', 'Amroha', 'Auraiya', 'Azamgarh', 'Baghpat', 'Bahraich', 'Ballia', 'Balrampur', 'Banda', 'Barabanki', 'Bareilly', 'Basti', 'Bhadohi', 'Bijnor', 'Budaun', 'Bulandshahr', 'Chandauli', 'Chitrakoot', 'Deoria', 'Etah', 'Etawah', 'Faizabad', 'Farrukhabad', 'Fatehpur', 'Firozabad', 'Gautam Buddh Nagar', 'Ghaziabad', 'Ghazipur', 'Gonda', 'Gorakhpur', 'Hamirpur', 'Hapur', 'Hardoi', 'Hathras', 'Jalaun', 'Jaunpur', 'Jhansi', 'Kannauj', 'Kanpur Dehat', 'Kanpur Nagar', 'Kasganj', 'Kaushambi', 'Kushinagar', 'Lakhimpur Kheri', 'Lalitpur', 'Lucknow', 'Maharajganj', 'Mahoba', 'Mainpuri', 'Mathura', 'Mau', 'Meerut', 'Mirzapur', 'Moradabad', 'Muzaffarnagar', 'Pilibhit', 'Pratapgarh', 'Rae Bareli', 'Rampur', 'Saharanpur', 'Sambhal', 'Sant Kabir Nagar', 'Shahjahanpur', 'Shamli', 'Shravasti', 'Siddharthnagar', 'Sitapur', 'Sonbhadra', 'Sultanpur', 'Unnao', 'Varanasi'],
       'Uttarakhand': ['Almora', 'Bageshwar', 'Chamoli', 'Champawat', 'Dehradun', 'Haridwar', 'Nainital', 'Pauri Garhwal', 'Pithoragarh', 'Rudraprayag', 'Tehri Garhwal', 'Udham Singh Nagar', 'Uttarkashi'],
       'West Bengal': ['Alipurduar', 'Bankura', 'Birbhum', 'Cooch Behar', 'Dakshin Dinajpur', 'Darjeeling', 'Hooghly', 'Howrah', 'Jalpaiguri', 'Jhargram', 'Kalimpong', 'Kolkata', 'Malda', 'Murshidabad', 'Nadia', 'North 24 Parganas', 'Paschim Bardhaman', 'Paschim Medinipur', 'Purba Bardhaman', 'Purba Medinipur', 'Purulia', 'South 24 Parganas', 'Uttar Dinajpur'],
       'Andaman and Nicobar Islands': [ 'Nicobar', 'North and Middle Andaman', 'South Andaman'],
       'Chandigarh': ['Chandigarh'],
       'Dadra and Nagar Haveli and Daman and Diu': [ 'Dadra', 'Nagar Haveli', 'Daman', 'Diu'],
       'Lakshadweep': [ 'Agatti', 'Amini', 'Andrott', 'Bitra', 'Chetlat', 'Kadmat', 'Kalpeni', 'Kavaratti', 'Kiltan', 'Minicoy',],
       'Delhi': ['Central Delhi', 'East Delhi', 'New Delhi', 'North Delhi', 'North East Delhi', 'North West Delhi', 'Shahdara', 'South Delhi', 'South East Delhi', 'South West Delhi', 'West Delhi',],
       'Puducherry': ['Puducherry', 'Karaikal', 'Yanam', 'Mahe'],
       'Ladakh': ['Leh', 'Kargil'],
       'Lakshadweep': ['Agatti', 'Amini', 'Andrott', 'Bitra', 'Chetlat', 'Kadmath', 'Kalpeni', 'Kavaratti', 'Kiltan', 'Minicoy'],
   };


  TextEditingController LabName=TextEditingController();
  TextEditingController Province=TextEditingController();
  TextEditingController LandMark=TextEditingController();
  TextEditingController City=TextEditingController();
  TextEditingController PinCode=TextEditingController();
  TextEditingController State=TextEditingController();
  TextEditingController Distric=TextEditingController();
  TextEditingController BankName=TextEditingController();
  TextEditingController BranchName=TextEditingController();
  TextEditingController AccountNumber=TextEditingController();
  TextEditingController IfscCode=TextEditingController();


  Future<void> ProvinceAlert(BuildContext context,) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Province'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount:  province.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text( province[index]),
                  onTap: () {
                    setState(() {
                      Province.text= province[index];
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without selecting any item
              },

              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  Future<void> BankNameAlert(BuildContext context,) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Bank'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount:  bankname.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text( bankname[index]),
                  onTap: () {
                    setState(() {
                      BankName.text= bankname[index];
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),

          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  Future<void>StateAlert (BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select State'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: StateDistric['State']!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(  StateDistric['State']![index] ),
                  onTap: () {
                    setState(() {
                      State.text=  StateDistric['State']![index];
                    });
                    Navigator.of(context).pop(); // Close the dialog on item selection
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without selecting any item
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  Future<void>DistricAlert (BuildContext context,String SelectedState) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Distric'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: StateDistric['$SelectedState']!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(  StateDistric['$SelectedState']![index] ),
                  onTap: () {
                    setState(() {
                      Distric.text=  StateDistric['$SelectedState']![index];
                    });
                    Navigator.of(context).pop(); // Close the dialog on item selection
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without selecting any item
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }






  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;  //834
    var width=MediaQuery.of(context).size.width;    //392
    return Scaffold(
      backgroundColor: Colors.white,
     appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Register",textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black,fontSize: width*4.6/100),),
          centerTitle:true,
         elevation: 0.0,
      ),
      body: ColorfulSafeArea(
        color: Colors.white,
        child: Stepper(
          type: StepperType.vertical,
          elevation: 0,
          currentStep:currentStep<4 ? currentStep:currentStep-1,
          onStepContinue: continueStep,
          onStepCancel: cancleStep,
          onStepTapped: onStepTapped,
          steps: [
            Step(isActive: currentStep>=0,
                state: currentStep>=1? StepState.complete:StepState.editing,
                title: Text("Lab Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: width*4.1/100),),
                content: Form(
                  key: LabDetails,
                  child: Column(
                    children: [
                          Container(height: height*12/100,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10,bottom: 5),
                                      child: Text("Lab Name*",style: TextStyle(fontWeight: FontWeight.bold,fontSize: width*3.9/100),),
                                    )
                                  ],
                                ),
                             Padding(
                                 padding: const EdgeInsets.only(left: 10),
                                 child: TextFormField(
                                   controller: LabName,
                                   cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color(0xFFE7E3E3),
                                     enabledBorder: OutlineInputBorder(
                                       borderRadius: BorderRadius.circular(10.0),
                                     ),
                                     border: InputBorder.none,
                                     hintText:"EX-Promise Laboratories",
                                     hintStyle: TextStyle(
                                       fontSize: width*3.9/100,
                                       color: Color(0xFFC0C0C0)
                                     )
                                   ),
                                   validator: (value) {
                                     if (value.toString().length<=2) {
                                       return 'Enter Your Lab Name';
                                     }
                                     return null;
                                   },
                                 ),
                               ),

                              ],
                            ),
                          ),
                     Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextFormField(
                            controller: Province,
                            onTap: () {
                              ProvinceAlert(context);
                            },
                            cursorColor: Colors.black,
                            readOnly: true,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFE7E3E3),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                border: InputBorder.none,
                                hintText:"Select Province",
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                    fontSize: width*3.9/100,
                                    color: Colors.black
                                ),
                                suffixIcon: Icon(Icons.arrow_drop_down_sharp,size: 30,)
                            ),
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'Select Province';
                              }
                              return null;
                            },

                          ),
                        ),


                    ],
                  ),
                )
            ),
            Step(isActive: currentStep>=1,
                state: currentStep>=2? StepState.complete:StepState.editing,
                title: Text("Address",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                content:  Form(
                 key: Address,
                  child: Column(
                    children: [
                      Container(height: height*11/100,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10,bottom: 0),
                                  child: Text("Land Mark/village/sector*",style: TextStyle(fontWeight: FontWeight.bold,fontSize: width*3.5/100),),
                                )
                              ],
                            ),
                           Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                  controller: LandMark,
                                    cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xFFE7E3E3),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      border: InputBorder.none,
                                      hintText:"EX-Sector 22",
                                      hintStyle: TextStyle(
                                          fontSize: width*3.9/100,
                                          color: Color(0xFFC0C0C0)
                                      )
                                  ),
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      return 'Land Mark/village/sector';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                          ],
                        ),
                      ),
                      Container(height: height*11/100,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10,bottom: 5),
                                  child: Text("City*",style: TextStyle(fontWeight: FontWeight.bold,fontSize: width*3.5/100),),
                                )
                              ],
                            ),
                             Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                  controller: City,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xFFE7E3E3),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      border: InputBorder.none,
                                      hintText:"EX-Panchkula",
                                      hintStyle: TextStyle(
                                          fontSize: width*3.9/100,
                                          color: Color(0xFFC0C0C0)
                                      )
                                  ),
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      return 'City Name';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                          ],
                        ),
                      ),
                      Container(height: height*11/100,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10,bottom: 5),
                                  child: Text("Pin Code*",style: TextStyle(fontWeight: FontWeight.bold,fontSize: width*3.5/100),),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextFormField(
                                controller: PinCode,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFE7E3E3),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    border: InputBorder.none,
                                    hintText:"101010",
                                    hintStyle: TextStyle(
                                        fontSize: width*3.9/100,
                                        color: Color(0xFFC0C0C0)
                                    )
                                ),
                                validator: (value) {
                                  if (value.toString().isEmpty) {
                                    return 'Pin Code';
                                  }
                                  return null;
                                },
                              ),
                            ),

                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 10,top: 5),
                          child: TextFormField(
                            onTap: () {
                              StateAlert(context);
                            },
                            controller: State,
                            cursorColor: Colors.black,
                            readOnly: true,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFE7E3E3),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                border: InputBorder.none,
                                hintText:"STATE",
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: width*3.9/100,
                                    color: Colors.black
                                ),
                               suffixIcon: Icon(Icons.arrow_drop_down_sharp,size: 30,)
                            ),
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'Select State';
                              }
                              return null;
                            },
                          ),
                        ),

                      SizedBox(height: 10,),

                      Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextFormField(
                            onTap: () {
                             State.text.isNotEmpty ? DistricAlert(context, State.text): Fluttertoast.showToast(msg: "Please Select State");
                            },
                            controller: Distric,
                            cursorColor: Colors.black,
                            readOnly: true,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFE7E3E3),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                border: InputBorder.none,
                                hintText:"DISTRIC",
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: width*3.9/100,
                                    color: Colors.black
                                ),
                              suffixIcon: Icon(Icons.arrow_drop_down_sharp,size: 30,)

                            ),
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'Select Distric';
                              }
                              return null;
                            },
                          ),
                        ),
                      SizedBox(height: 10,),

                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          onTap:(){
                            _requestLocationPermission();
                               },

                          cursorColor: Colors.black,
                          readOnly: true,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFE7E3E3),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              border: InputBorder.none,
                              hintText:"Lab Current Location",
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width*3.9/100,
                                  color: Colors.black
                              ),
                              suffixIcon: Icon(Icons.location_on_sharp,size: 30,)

                          ),
                          // validator: (value) {
                          //   if (value.toString().isEmpty) {
                          //     return 'c';
                          //   }
                          //   return null;
                          // },
                        ),
                      ),


                      SizedBox(height: 10,),
                      Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextField(
                            cursorColor: Colors.black,
                            readOnly: true,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFE7E3E3),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                border: InputBorder.none,
                                hintText:"INDIA",
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: width*3.9/100,
                                    color: Colors.black
                                )

                            ),
                          ),
                        ),

                    ],
                  ),
                )
            ),
            Step(isActive: currentStep>=2 ,
                state: currentStep>=3? StepState.complete:StepState.editing,
                title: Text("Bank Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                content: Form(
                  key: BankDetails,
                  child: Column(
                    children: [
                     Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextFormField(
                            onTap: () {
                              BankNameAlert(context);
                            },
                            controller: BankName,
                            cursorColor: Colors.black,
                            readOnly: true,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFE7E3E3),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                border: InputBorder.none,
                                hintText:"Bank Name",
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: width*3.9/100,
                                    color: Colors.black
                                ),
                                suffixIcon: Icon(Icons.arrow_drop_down_sharp,size: 30,),
                              prefixIcon: Icon(Icons.account_balance,color: Colors.grey,)
                            ),
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'Select Bank';
                              }
                              return null;
                            },
                          ),
                        ),
                      SizedBox(height: 10,),
                      Container(height: height*12/100,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10,bottom: 5),
                                  child: Text("Branch Name*",style: TextStyle(fontWeight: FontWeight.bold,fontSize: width*3.9/100),),
                                )
                              ],
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                  controller: BranchName,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xFFE7E3E3),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      border: InputBorder.none,
                                      hintText:"Panchkula",
                                      hintStyle: TextStyle(
                                          fontSize: width*3.9/100,
                                          color: Color(0xFFC0C0C0)
                                      )
                                  ),
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      return 'Branch Name';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                          ],
                        ),
                      ),
                      Container(height: height*12/100,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10,bottom: 5),
                                  child: Text("Account Number*",style: TextStyle(fontWeight: FontWeight.bold,fontSize: width*3.9/100),),
                                )
                              ],
                            ),
                           Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                  controller: AccountNumber,
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xFFE7E3E3),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      border: InputBorder.none,
                                      hintText:"8090 1020 11XX XXXX",
                                      hintStyle: TextStyle(
                                          fontSize: width*3.9/100,
                                          color: Color(0xFFC0C0C0)
                                      )

                                  ),
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      return 'Account Number';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                          ],
                        ),
                      ),
                      Container(height: height*12/100,

                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10,bottom: 5),
                                  child: Text("Re-Account number*",style: TextStyle(fontWeight: FontWeight.bold,fontSize: width*3.9/100),),
                                )
                              ],
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xFFE7E3E3),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      border: InputBorder.none,
                                      hintText:"8090 1020 11XX XXXX",
                                      hintStyle: TextStyle(
                                          fontSize: width*3.9/100,
                                          color: Color(0xFFC0C0C0)
                                      )
                                  ),
                                  validator: (value) {
                                    if (value != AccountNumber.text) {
                                      return 'Account Number Not Same';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                          ],
                        ),
                      ),
                      Container(
                      height: height*12/100,

                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10,bottom: 5),
                                  child: Text("IFSC Code",style: TextStyle(fontWeight: FontWeight.bold,fontSize: width*3.9/100),),
                                )
                              ],
                            ),
                         Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                  controller: IfscCode,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xFFE7E3E3),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      border: InputBorder.none,
                                      hintText:"SBIN00365",
                                      hintStyle: TextStyle(
                                          fontSize: width*3.9/100,
                                          color: Color(0xFFC0C0C0)
                                      )

                                  ),
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      return 'Ifsc Code';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                          ],
                        ),
                      ),

                    ],
                  ),
                )),
            Step(isActive: currentStep>=3 ,
                state: currentStep>=4? StepState.complete:StepState.editing,
                title: Text("Upload Documents",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)), content: Column(
                  children: [
                    Container(height: height*20/100,

                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10,bottom: 5),
                                child: Text("Addhar Card*",style: TextStyle(fontWeight: FontWeight.bold,fontSize: width*3.9/100),),
                              )
                            ],
                          ),
                          InkWell(onTap: () {
                           AddharCardpickImage(ImageSource.gallery,);
                          },
                            child: CustomPaint(
                              painter: DashedBorderPainter(),
                              child: Container(
                                  height: height*15/100,width: height*15/100,
                                  decoration: BoxDecoration(
                                    borderRadius:  BorderRadius.circular(5),
                                    color: Color(0xFFE7E3E3),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: AddharimageFile != null
                                        ? Image.file(AddharimageFile!, fit: BoxFit.cover) // Display the image if it's not null
                                        : Center(
                                      child: Image(image: AssetImage("assets/images/Document.png"),width: 20,), // Display a message if imageFile is null
                                    ),
                                  //  child: AddharCardimageUrl.isNotEmpty ? Image.network(AddharCardimageUrl):Image(image: AssetImage("assets/images/Document.png"),width: 20,),
                                  )
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(height: height*20/100,

                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10,bottom: 5),
                                child: Text("Pan Card*",style: TextStyle(fontWeight: FontWeight.bold,fontSize: width*3.9/100),),
                              )
                            ],
                          ),
                          InkWell(onTap: () {
                            PanCardpickImage(ImageSource.gallery,);
                          },
                            child: CustomPaint(
                              painter: DashedBorderPainter(),
                              child: Container(
                                height: height*15/100,width: height*15/100,
                                decoration: BoxDecoration(
                                  borderRadius:  BorderRadius.circular(5),
                                  color: Color(0xFFE7E3E3),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                  child: PanimageFile != null
                                      ? Image.file(PanimageFile!, fit: BoxFit.cover) // Display the image if it's not null
                                      : Center(
                                    child: Image(image: AssetImage("assets/images/Document.png"),width: 20,), // Display a message if imageFile is null
                                  ),                                )
                                ),
                              ),
                            ),

                        ],
                      ),
                    ),
              ],

                )),
          ],
        ),
      ),
    );
  }

  //create a Function to get Lab Current Location
 Future<void> _requestLocationPermission() async {
   final permissionStatus = await Geolocator.requestPermission();
   if (permissionStatus == LocationPermission.denied) {
     setState(() {
       Fluttertoast.showToast(
         msg: "please give permission to the location",
         toastLength: Toast.LENGTH_SHORT,
         gravity: ToastGravity.BOTTOM,
         timeInSecForIosWeb: 1,
         backgroundColor: Colors.grey,
         textColor: Colors.white,
         fontSize: 16.0,
       );
     }
     );
   }
   else if (permissionStatus == LocationPermission.always ||
       permissionStatus == LocationPermission.whileInUse) {
     setState(() {
       _getLocation();
     });
   }
 }
 late LatLng _currentPosition;
 Future<void> _getLocation() async {
   Position position = await Geolocator.getCurrentPosition(
     desiredAccuracy: LocationAccuracy.high,
   );

   List<Placemark> placemarks = await placemarkFromCoordinates(
     position.latitude,
     position.longitude,
   );
   if(placemarks.isNotEmpty){
     _currentPosition = LatLng(position.latitude, position.longitude);
   }
 }

 var auth=FirebaseAuth.instance.currentUser?.uid;
 String PanCardimageUrl="";
 String AddharCardimageUrl="";
 File? AddharimageFile;
 File? PanimageFile;
 final picker = ImagePicker();
 // For AddharCard
 Future<void> AddharCardpickImage(ImageSource source,) async {
   final pickedFile = await picker.pickImage(source: source);
   if (pickedFile != null) {
     setState(() {
       AddharimageFile = File(pickedFile.path);
       AddharCarduploadImage();
     });
   }
 }
 Future<void> AddharCarduploadImage() async {
   if (AddharimageFile != null) {
     var ref = FirebaseStorage.instance.ref().child('laboratory documents').child('$auth+"AddharCard".jpg');
     UploadTask uploadTask = ref.putFile(File(AddharimageFile!.path));
     TaskSnapshot snapshot = await uploadTask;
     setState(() async {
       AddharCardimageUrl = await snapshot.ref.getDownloadURL();
     });
    }
 }
 //For PanCard
 Future<void> PanCardpickImage(ImageSource source,) async {
   final pickedFile = await picker.pickImage(source: source);
   if (pickedFile != null) {
     setState(() {
       PanimageFile = File(pickedFile.path);
       PanCarduploadImage();
     });
   }
 }
 Future<void> PanCarduploadImage() async {
   if (PanimageFile != null) {
     var ref = FirebaseStorage.instance.ref().child('laboratory documents').child('$auth+"PanCard".jpg');
     UploadTask uploadTask = ref.putFile(File(PanimageFile!.path));
     TaskSnapshot snapshot = await uploadTask;
     setState(() async {
       PanCardimageUrl = await snapshot.ref.getDownloadURL();
     });
   }
 }

 // Create function to Sent Registation data in firebase


 RegisterData(){
   try {
     final details = <String, dynamic>{
       "AacountStatus": false,
       "Number": widget.number,
       "LabDetails": {
         "labName": LabName.text,
         "selectProvince": Province.text,
       },
       "Address": {
         "landMark": LandMark.text,
         "city": City.text,
         "pinCode":PinCode.text,
         "state": State.text,
         "district": Distric.text,
         "country": "INDIA",
         "LatLng": _currentPosition.toString()
       },
       "BankDetails": {
         "bankName": BankName.text,
         "branchName": BranchName.text,
         "accountNo": AccountNumber.text,
         "ifscCode": IfscCode.text,
       },
       "documentUrl": {
         "addharCard" : AddharCardimageUrl,
         "panCard" : PanCardimageUrl,
       }
     };

     FirebaseFirestore.instance.collection("laboratory").doc(auth).set(details);

     Fluttertoast. showToast(msg:"Registation request send ",);
     Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
     loginStatus();

   }
   catch(e){
     Fluttertoast.showToast(msg:"sorry");
   }
 }
}


// create a class to CustomContainer
class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54 // Border color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0; // Border width

    final double dashWidth = 5; // Width of each dash
    final double dashSpace = 5; // Space between dashes

    // Draw top border
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Draw right border
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    // Draw bottom border
    startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX + dashWidth, size.height),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Draw left border
    startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
