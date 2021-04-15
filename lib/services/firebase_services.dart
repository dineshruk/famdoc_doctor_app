import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  CollectionReference category =
      FirebaseFirestore.instance.collection('category');
  CollectionReference packages =
      FirebaseFirestore.instance.collection('packages');

  Future<void> publishPackage({id}) {
    return packages.doc(id).update({
      'published': true,
    });
  }

  Future<void> unpublishPackage({id}) {
    return packages.doc(id).update({
      'published': false,
    });
  }

   Future<void> deletePackage({id}) {
    return packages.doc(id).delete();
  }
}
