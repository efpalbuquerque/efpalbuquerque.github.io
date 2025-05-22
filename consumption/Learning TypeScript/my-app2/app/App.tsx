import React, { useState, useEffect } from 'react';
import { View, Text, TextInput, Button, StyleSheet, Alert, Platform } from 'react-native';
import * as Notifications from 'expo-notifications';
import * as SQLite from 'expo-sqlite';

// Define our custom SQLite database interface
interface MySQLiteDatabase {
  transaction: (callback: (tx: any) => void) => void;
}

// Set up notification handling
Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldShowAlert: true,
    shouldPlaySound: false,
    shouldSetBadge: false,
  }),
});

export default function App() {
  const [name, setName] = useState('');
  const [favoriteColor, setFavoriteColor] = useState('');
  const [db, setDb] = useState<MySQLiteDatabase | null>(null);

  useEffect(() => {
    if (Platform.OS !== 'web') {
      initDb();
    }
    registerForNotifications();
  }, []);

  const initDb = async () => {
    try {
      // Cast the returned database instance to our custom type
      const dbInstance = (await SQLite.openDatabaseAsync('survey.db')) as unknown as MySQLiteDatabase;
      setDb(dbInstance);
      dbInstance.transaction((tx: any) => {
        tx.executeSql(
          `CREATE TABLE IF NOT EXISTS responses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            favoriteColor TEXT
          );`
        );
      });
    } catch (error) {
      console.error('Error initializing database:', error);
    }
  };

  const registerForNotifications = async () => {
    const { status } = await Notifications.requestPermissionsAsync();
    if (status !== 'granted') {
      Alert.alert('Notification permission not granted');
    }
  };

  // Use trigger with seconds and repeats (without a "type" property)
  const scheduleNotification = async () => {
    const trigger = { type: 'timeInterval', seconds: 2, repeats: false } as Notifications.NotificationTriggerInput;

    await Notifications.scheduleNotificationAsync({
      content: {
        title: "Survey Reminder",
        body: "Don't forget to complete the survey!",
      },
      trigger,
    });
  };

  const handleSubmit = () => {
    if (!name || !favoriteColor) {
      Alert.alert("Please fill in all fields");
      return;
    }
    if (db) {
      db.transaction((tx: any) => {
        tx.executeSql(
          "INSERT INTO responses (name, favoriteColor) VALUES (?, ?);",
          [name, favoriteColor],
          (_: any, result: any) => {
            Alert.alert("Response saved!");
            setName('');
            setFavoriteColor('');
          },
          (_: any, error: any) => {
            console.error("Error saving response:", error);
            return false;
          }
        );
      });
    } else {
      Alert.alert("Database not available");
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Survey App</Text>
      <Button title="Send Notification" onPress={scheduleNotification} />

      <Text style={styles.label}>What is your name?</Text>
      <TextInput
        style={styles.input}
        placeholder="Enter your name"
        value={name}
        onChangeText={setName}
      />

      <Text style={styles.label}>What is your favorite color?</Text>
      <TextInput
        style={styles.input}
        placeholder="Enter your favorite color"
        value={favoriteColor}
        onChangeText={setFavoriteColor}
      />

      <Button title="Submit Response" onPress={handleSubmit} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 20,
    justifyContent: 'center'
  },
  title: {
    fontSize: 24,
    marginBottom: 20,
    textAlign: 'center'
  },
  label: {
    fontSize: 18,
    marginTop: 10
  },
  input: {
    borderWidth: 1,
    borderColor: '#ccc',
    padding: 10,
    marginVertical: 10
  }
});
