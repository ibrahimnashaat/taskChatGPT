
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    print('Database initialization');
    String path = await getDatabasesPath();
    path = join(path, 'gpt.db');
    print('Database path: $path');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (database, version) async {
        Batch batch = database.batch();
        batch.execute(
          "CREATE TABLE historyChats(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)",
        );
        batch.execute(
          "CREATE TABLE messages(id INTEGER PRIMARY KEY AUTOINCREMENT, chatId INTEGER, messageText TEXT, txt TEXT)",
        );
        await batch.commit();
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        print('Upgrading database from version $oldVersion to $newVersion');
      },
      onOpen: (Database db) async {
        print('Database opened');
      },
    );
  }

  Future<void> deleteDatabase() async {
    String path = await getDatabasesPath();
    path = join(path, 'gpt.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
    print('Database deleted');
  }

  Future<int> insertMessage(int chatId,  String messageText, String txt) async {
    Database db = await instance.database;
    try {
      int result = await db.insert(
        'messages',
        {'chatId': chatId, 'messageText': messageText, 'txt': txt},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      print('Inserted message: $result');
      return result;
    } catch (e) {
      print('Error inserting message: $e');
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getMessagesForChat(int chatId) async {
    Database db = await instance.database;
    return await db.query('messages', where: 'chatId = ?', whereArgs: [chatId]);
  }

  Future<int> insertChat(String name) async {
    Database db = await instance.database;
    try {
      int result = await db.insert(
        'historyChats',
        {'name': name},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      print('Inserted chat: $result');
      print(db);
      return result;
    } catch (e) {
      print('Error inserting chat: $e');
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getChats() async {
    Database db = await instance.database;
    return await db.query('historyChats');
  }

  Future<int> updateChat(int id, String name) async {
    Database db = await instance.database;
    return await db.update('historyChats', {'name': name}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteChat(int id) async {
    Database db = await instance.database;
    return await db.delete('historyChats', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllChats() async {
    Database db = await instance.database;
    return await db.delete('historyChats');
  }


  Future<Map<String, dynamic>?> getLastUserMessage(int chatId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> messages = await db.rawQuery('''
    SELECT * FROM messages WHERE chatId = ? AND txt = 'user' ORDER BY id DESC LIMIT 1
  ''', [chatId]);
    return messages.isNotEmpty ? messages.first : null;
  }

}
