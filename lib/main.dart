import 'package:flutter/material.dart';
import 'color.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Memer",
      theme: ThemeData(
        primaryColor: clrp,
        // accentColor: clrs,
        buttonColor: clrp,
      ),
      home: Scaffold(
        backgroundColor: clrs,
        appBar: AppBar(
          centerTitle: true,
          title: Text("- - Memer - -",
          style: TextStyle(
            fontFamily: 'meme',
            fontWeight: FontWeight.bold,
            fontSize: 40,
            color: clrs,
            wordSpacing: 10,
          ),),
        ),

      body: Main(),
      ),
    );
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {

  final String url = "https://api.imgflip.com/get_memes";
  String memeurl,mainurl;
  bool isLoading = false;

 int boxes;

  var data;
  Image mainImage;
  var mainIndex;
  var postdata;

  bool generate,template,gallery,share;

  List<String> response;

  Future getJsondata() async{

    setState(() {
      isLoading = true;
      print(isLoading);
    });
    var response = await http.get(Uri.encodeFull(url));

    setState(() {
      var temp = jsonDecode(response.body)['data']['memes'];

      data = temp;
    });
    
     setState(() {
      isLoading = false;
      print(isLoading);
    });

    print(isLoading);

    }

  Future meme(String posturl) async{
    var response = await http.post(
      Uri.encodeFull(posturl),
    );

    var temp = jsonDecode(response.body)['data']['url'];

    setState(() {
      
      mainurl = temp;

       mainImage = Image(image:NetworkImage(mainurl),
       loadingBuilder:(BuildContext context, Widget child,
            ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes
                  : null,
            ),
          );
        },
       );
    });}

  @override
  void initState() {
    super.initState();

    print(isLoading);

    mainImage = Image(image: AssetImage("images/icon.png"),);
    mainIndex = null;

    response = ["","","","","","","","","",""];

    this.getJsondata();

    generate = false;
    template = false;
    share = false;
    gallery = false;

    boxes = 0 ;
   
  }


  @override
  Widget build(BuildContext context) {
    return  NotificationListener<OverscrollIndicatorNotification>(
    onNotification: (overscroll) {
      overscroll.disallowGlow();
    },
          child: SingleChildScrollView(
                child: Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
                  child: SizedBox(
                    child: mainImage,
                    height: 300,
                    width: 300,
                    ),
                  ),

                  Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: SizedBox(
                    width: 300,
                    child: Form(
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: boxes,
                          itemBuilder: (context,index) => Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: SizedBox(
                            width: 300,
                            child:  TextFormField(
                              onChanged: (text){
                                response[index] = text;
                              },
                            decoration: InputDecoration(
                              labelText: "Text ${index + 1}",
                            ),
                            ),
                        ),
                          ) 
                        ),
                      ),
                    ),
                  ),
                 
                  Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                  child: SizedBox(
                    
                      width: 300,
                      child: RaisedButton(
                        child: Text("Generate Meme",
                        style: TextStyle(
            fontFamily: 'meme',
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: clrs,
            wordSpacing: 10,
          ),),
                      // color: clrp,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0)
                      ),
                      onPressed: (){

                      (generate)?
                      setState(()

                      {
                      memeurl = "https://api.imgflip.com/caption_image?template_id=${data[mainIndex]['id']}&username=devang&password=devang123";
                      for(int i=0; i<boxes;i++)
                      {
                        memeurl += "&boxes[${i}][text]=${response[i]}";
                      }
                      this.meme(memeurl);

                      share = true;
                      gallery = true;

                    }): showDialog(context: context,
                    builder: (context)=> 
                         AlertDialog(
                           backgroundColor: clrs,
                          title: Center(
                            child: Text("Generate Meme",
                            style: TextStyle(
                              color: clrp,
                            ),)
                            ),
                          content:Container(
                              width: 450,
                              child: Text("Please select a template first"),
                    ),));
                      }
                      ),
                  ),
                  ),
                  Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: SizedBox(
                      width: 300,
                      child: RaisedButton(
                      child: Text("Select Template",
                      style: TextStyle(
            fontFamily: 'meme',
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: clrs,
            wordSpacing: 10,
          ),),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0)
                      ),
                      // color: clrp,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context)=> 
                         AlertDialog(
                           backgroundColor: clrs,
                          title: Center(
                            child: Text("Select Template",
                            style: TextStyle(
                              color: clrp,
                            ),)
                            ),
                          content:Container(
                              width: 450,
                              child: (isLoading)? Text("Data Loading Please Try again") : GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5), 
                                itemCount: data.length,
                                padding: EdgeInsets.all(0),
                                itemBuilder: (context,index) => GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      memeurl = "https://api.imgflip.com/caption_image?template_id=${data[index]['id']}&username=devang&password=devang123";
                                      for(int i=0; i<data[index]['box_count'];i++)
                                      {
                                        memeurl += "&boxes[${i}][text]=Text ${i + 1}";
                                      }

                                      boxes = data[index]['box_count'];

                                      this.meme(memeurl);
                                      mainIndex = index;

                                      generate = true;

                                      Navigator.of(context).pop();
                                    });

                                  },
                                  child: SizedBox(
                                  child: Image(image: NetworkImage(data[index]['url']),
                                  loadingBuilder:(BuildContext context, Widget child,
            ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes
                  : null,
            ),
          );
        },
                                  ),
                                  height: 300,
                                  width: 300,
                                  ),
                                ),
                                  ),
                            ),
                            ),
                        ) 
                        )
                          ),
                      ),
//                   Padding(
//                   padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
//                   child: SizedBox(
//                       width: 300,
//                       child: RaisedButton(
//                       child: Text("Save to Gallery",
//                       style: TextStyle(
//             fontFamily: 'meme',
//             fontWeight: FontWeight.bold,
//             fontSize: 30,
//             color: clrs,
//             wordSpacing: 10,
//           ),),
//                       color: clrp,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(40.0)
//                       ),
//                       onPressed: (){
//                         String path =
//         mainurl;
//         if(!gallery) {
//   showDialog(context: context,
//                     builder: (context)=> 
//                          AlertDialog(
//                            backgroundColor: clrs,
//                           title: Center(
//                             child: Text("Save to Gallery",
//                             style: TextStyle(
//                               color: clrp,
//                             ),)
//                             ),
//                           content:Container(
//                               width: 450,
//                               child: Text("Please generate a meme first"),
//                     ),));
// }
//     GallerySaver.saveImage(path).then((bool success) {
//       setState(() {
//         print('Image is saved');
//       });
//     });
              
//                       }
//                       ),
//                   ),
//                   ),
                  Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 30),
                  child: SizedBox(
                      width: 300,
                      child: RaisedButton(
                      child: Text("Share",
                      style: TextStyle(
            fontFamily: 'meme',
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: clrs,
            wordSpacing: 10,
          ),),
                      color: clrp,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0)
                      ),
                      onPressed: () async {

                        if(!share) {
  showDialog(context: context,
                    builder: (context)=> 
                         AlertDialog(
                           backgroundColor: clrs,
                          title: Center(
                            child: Text("Share",
                            style: TextStyle(
                              color: clrp,
                            ),)
                            ),
                          content:Container(
                              width: 450,
                              child: Text("Please generate a meme first"),
                    ),));
}
var request = await HttpClient().getUrl(Uri.parse(mainurl));
var response = await request.close();
Uint8List bytes = await consolidateHttpClientResponseBytes(response);
await Share.file('Memer Meme', 'memer.jpg', bytes, 'image/jpg');


print("shared");
                      }
                      ),
                  ),
                  ),

              ],
            ),
          ),
        ),
    );
  }
}

