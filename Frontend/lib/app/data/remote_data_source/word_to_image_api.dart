import 'package:firebase_database/firebase_database.dart';
import 'package:qodra/app/data/models/word_model.dart';
class WordToImageService{



  Future<WordModel?> getWordData() async{
    WordModel ? model;
  await  FirebaseDatabase.instance.reference().child(
        "wordToImage").once().then((
        DatabaseEvent snapshot) async{
        model= await WordModel.fromJson(snapshot.snapshot.value);
      // print('values  =>'+model.imageUrl.toString());

    });
     return model;
  }
}