import React, { useState } from 'react';
import { View, Text, TouchableOpacity, Button, StyleSheet } from 'react-native';

export default function App() {
  // State variables (useState hook)
  const [count, setCount] = useState(0);
  const [darkMode, setDarkMode] = useState(false);

  // Event handler functions
  const increaseCount = () => {
    setCount(count + 1);
  };

  const decreaseCount = () => {
    setCount(count - 1);
  };

  const resetCount = () => {
    setCount(0);
  };

  const toggleMode = () => {
    setDarkMode(!darkMode);
  };

  return (
    // Outer container View - background changes with darkMode state
    <View
      style={[
        styles.container,
        darkMode ? styles.darkBackground : styles.lightBackground,
      ]}
    >
      {/* Title */}
      <Text
        style={[styles.title, darkMode ? styles.lightText : styles.darkText]}
      >
        Cross-Platform Counter App
      </Text>

      <Text
        style={[styles.subtitle, darkMode ? styles.lightText : styles.darkText]}
      >
        Built using React Native
      </Text>

      {/* Box that shows the count */}
      <View style={styles.countBox}>
        <Text style={styles.countLabel}>Current Count</Text>
        <Text style={styles.countValue}>{count}</Text>
      </View>

      {/* Row with two buttons side by side (Flexbox row) */}
      <View style={styles.buttonRow}>
        <TouchableOpacity
          style={[styles.button, styles.minusButton]}
          onPress={decreaseCount}
        >
          <Text style={styles.buttonText}>- Decrease</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={[styles.button, styles.plusButton]}
          onPress={increaseCount}
        >
          <Text style={styles.buttonText}>+ Increase</Text>
        </TouchableOpacity>
      </View>

      {/* Reset button using the built-in Button component */}
      <View style={styles.resetContainer}>
        <Button title="Reset" onPress={resetCount} color="#e67e22" />
      </View>

      {/* Toggle button for dark / light mode */}
      <TouchableOpacity style={styles.modeButton} onPress={toggleMode}>
        <Text style={styles.buttonText}>
          Switch to {darkMode ? 'Light' : 'Dark'} Mode
        </Text>
      </TouchableOpacity>

      {/* Text that shows the current mode */}
      <Text
        style={[styles.modeText, darkMode ? styles.lightText : styles.darkText]}
      >
        Current Mode: {darkMode ? 'Dark' : 'Light'}
      </Text>
    </View>
  );
}

// Styles using StyleSheet
const styles = StyleSheet.create({
  container: {
    flex: 1,                    // take the full screen
    justifyContent: 'center',   // center vertically
    alignItems: 'center',       // center horizontally
    padding: 20,
  },
  lightBackground: {
    backgroundColor: '#f2f2f2',
  },
  darkBackground: {
    backgroundColor: '#1e1e1e',
  },
  darkText: {
    color: '#222222',
  },
  lightText: {
    color: '#ffffff',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 5,
    textAlign: 'center',
  },
  subtitle: {
    fontSize: 16,
    marginBottom: 30,
  },
  countBox: {
    backgroundColor: '#ffffff',
    width: 200,
    padding: 20,
    borderRadius: 15,
    alignItems: 'center',
    marginBottom: 30,
    elevation: 5,               // shadow on Android
    shadowColor: '#000',        // shadow on iOS
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.3,
    shadowRadius: 4,
  },
  countLabel: {
    fontSize: 18,
    color: '#555555',
  },
  countValue: {
    fontSize: 60,
    fontWeight: 'bold',
    color: '#2c3e50',
  },
  buttonRow: {
    flexDirection: 'row',           // put buttons in a row
    justifyContent: 'space-between',
    marginBottom: 20,
  },
  button: {
    paddingVertical: 12,
    paddingHorizontal: 20,
    borderRadius: 8,
    marginHorizontal: 8,
  },
  plusButton: {
    backgroundColor: '#27ae60',
  },
  minusButton: {
    backgroundColor: '#c0392b',
  },
  buttonText: {
    color: '#ffffff',
    fontSize: 16,
    fontWeight: 'bold',
  },
  resetContainer: {
    width: 150,
    marginBottom: 20,
  },
  modeButton: {
    backgroundColor: '#2980b9',
    paddingVertical: 12,
    paddingHorizontal: 20,
    borderRadius: 8,
    marginBottom: 15,
  },
  modeText: {
    fontSize: 16,
  },
});