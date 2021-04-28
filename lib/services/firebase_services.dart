import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  User user = FirebaseAuth.instance.currentUser;

  CollectionReference category =
      FirebaseFirestore.instance.collection('category');
  CollectionReference packages =
      FirebaseFirestore.instance.collection('packages');
  CollectionReference doctorcover =
      FirebaseFirestore.instance.collection('doctorcover');
  CollectionReference coupons =
      FirebaseFirestore.instance.collection('coupons');

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

  Future<void> saveCover(url) {
    return doctorcover.add({
      'imageUrl': url,
      'doctoruid': user.uid,
    });
  }

  Future<void> deleteBanner({id}) {
    return doctorcover.doc(id).delete();
  }

  Future<void> saveCoupon({document,title, discountRate,expiry,details,active}) {
    if(document==null){
       return coupons.doc(title).set({
      'title' : title,
      'discountRate' : discountRate,
      'Expiry' : expiry,
      'details' : details,
      'active' : active,
      'doctorId' : user.uid,
    });
    }
      return coupons.doc(title).update({
      'title' : title,
      'discountRate' : discountRate,
      'Expiry' : expiry,
      'details' : details,
      'active' : active,
      'doctorId' : user.uid,
    });
   
  }
}
