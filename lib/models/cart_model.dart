import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel extends ChangeNotifier {
  final List<List<String>> _foodItems = [];
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  List<List<String>> get foodItems => _foodItems;

  // Constructor to fetch data immediately
  CartModel() {
    fetchPopularItems();
  }

  Future<void> fetchPopularItems() async {
    try {
      // Clear existing items
      _foodItems.clear();

      // Get reference to the breakfast collection
      final CollectionReference breakfastCollection =
      FirebaseFirestore.instance.collection('popular');

      // Get all documents in the collection
      QuerySnapshot querySnapshot = await breakfastCollection.get();

      // Loop through each document
      for (var doc in querySnapshot.docs) {
        // Convert document data to map
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Add food item in required format including document ID as the last element
        _foodItems.add([
          data['item_name'] ?? '',
          data['item_price'] ?? '',
          data['item_image'] ?? '',
          data['item_rating'] ?? '',
          data['item_description'] ?? '',
          doc.id // Store the document ID
        ]);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching food items: $e');
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBreakfastItems() async {
    try {
      // Clear existing items
      _foodItems.clear();

      // Get reference to the breakfast collection
      final CollectionReference breakfastCollection =
      FirebaseFirestore.instance.collection('breakfast');

      // Get all documents in the collection
      QuerySnapshot querySnapshot = await breakfastCollection.get();

      // Loop through each document
      for (var doc in querySnapshot.docs) {
        // Convert document data to map
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Add food item in required format including document ID as the last element
        _foodItems.add([
          data['item_name'] ?? '',
          data['item_price'] ?? '',
          data['item_image'] ?? '',
          data['item_rating'] ?? '',
          data['item_description'] ?? '',
          doc.id // Store the document ID
        ]);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching food items: $e');
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLunchItems() async {
    try {
      // Clear existing items
      _foodItems.clear();

      // Get reference to the breakfast collection
      final CollectionReference breakfastCollection =
      FirebaseFirestore.instance.collection('lunch');

      // Get all documents in the collection
      QuerySnapshot querySnapshot = await breakfastCollection.get();

      // Loop through each document
      for (var doc in querySnapshot.docs) {
        // Convert document data to map
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Add food item in required format including document ID as the last element
        _foodItems.add([
          data['item_name'] ?? '',
          data['item_price'] ?? '',
          data['item_image'] ?? '',
          data['item_rating'] ?? '',
          data['item_description'] ?? '',
          doc.id // Store the document ID
        ]);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching food items: $e');
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDrinkItems() async {
    try {
      // Clear existing items
      _foodItems.clear();

      // Get reference to the breakfast collection
      final CollectionReference breakfastCollection =
      FirebaseFirestore.instance.collection('drinks');

      // Get all documents in the collection
      QuerySnapshot querySnapshot = await breakfastCollection.get();

      // Loop through each document
      for (var doc in querySnapshot.docs) {
        // Convert document data to map
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Add food item in required format including document ID as the last element
        _foodItems.add([
          data['item_name'] ?? '',
          data['item_price'] ?? '',
          data['item_image'] ?? '',
          data['item_rating'] ?? '',
          data['item_description'] ?? '',
          doc.id // Store the document ID
        ]);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching food items: $e');
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDessertItems() async {
    try {
      // Clear existing items
      _foodItems.clear();

      // Get reference to the breakfast collection
      final CollectionReference breakfastCollection =
      FirebaseFirestore.instance.collection('dessert');

      // Get all documents in the collection
      QuerySnapshot querySnapshot = await breakfastCollection.get();

      // Loop through each document
      for (var doc in querySnapshot.docs) {
        // Convert document data to map
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Add food item in required format including document ID as the last element
        _foodItems.add([
          data['item_name'] ?? '',
          data['item_price'] ?? '',
          data['item_image'] ?? '',
          data['item_rating'] ?? '',
          data['item_description'] ?? '',
          doc.id // Store the document ID
        ]);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching food items: $e');
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSnacksItems() async {
    try {
      // Clear existing items
      _foodItems.clear();

      // Get reference to the breakfast collection
      final CollectionReference breakfastCollection =
      FirebaseFirestore.instance.collection('snacks');

      // Get all documents in the collection
      QuerySnapshot querySnapshot = await breakfastCollection.get();

      // Loop through each document
      for (var doc in querySnapshot.docs) {
        // Convert document data to map
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Add food item in required format including document ID as the last element
        _foodItems.add([
          data['item_name'] ?? '',
          data['item_price'] ?? '',
          data['item_image'] ?? '',
          data['item_rating'] ?? '',
          data['item_description'] ?? '',
          doc.id // Store the document ID
        ]);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching food items: $e');
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBiscuitItems() async {
    try {
      // Clear existing items
      _foodItems.clear();

      // Get reference to the breakfast collection
      final CollectionReference breakfastCollection =
      FirebaseFirestore.instance.collection('biscuits');

      // Get all documents in the collection
      QuerySnapshot querySnapshot = await breakfastCollection.get();

      // Loop through each document
      for (var doc in querySnapshot.docs) {
        // Convert document data to map
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Add food item in required format including document ID as the last element
        _foodItems.add([
          data['item_name'] ?? '',
          data['item_price'] ?? '',
          data['item_image'] ?? '',
          data['item_rating'] ?? '',
          data['item_description'] ?? '',
          doc.id // Store the document ID
        ]);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching food items: $e');
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDairyItems() async {
    try {
      // Clear existing items
      _foodItems.clear();

      // Get reference to the breakfast collection
      final CollectionReference breakfastCollection =
      FirebaseFirestore.instance.collection('diary');

      // Get all documents in the collection
      QuerySnapshot querySnapshot = await breakfastCollection.get();

      // Loop through each document
      for (var doc in querySnapshot.docs) {
        // Convert document data to map
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Add food item in required format including document ID as the last element
        _foodItems.add([
          data['item_name'] ?? '',
          data['item_price'] ?? '',
          data['item_image'] ?? '',
          data['item_rating'] ?? '',
          data['item_description'] ?? '',
          doc.id // Store the document ID
        ]);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching food items: $e');
      }
      _isLoading = false;
      notifyListeners();
    }
  }

}