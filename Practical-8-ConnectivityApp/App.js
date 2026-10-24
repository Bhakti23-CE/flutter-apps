// App.js
// Experiment 8: Connectivity-Based Cross-Platform Application (Expo + NetInfo)

import React, { useCallback, useEffect, useRef, useState } from 'react';
import {
  ActivityIndicator,
  Animated,
  Platform,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import { StatusBar } from 'expo-status-bar';
import NetInfo from '@react-native-community/netinfo';

// ---------- Colours ----------
const ONLINE_COLOR = '#2ecc71'; // green
const OFFLINE_COLOR = '#e74c3c'; // red
const WARNING_COLOR = '#f39c12'; // orange (used only for "checking" text)

// ---------- Helper: convert NetInfo's state into the values our screen needs ----------
function toScreenState(netInfoState) {
  return {
    type: netInfoState.type, // 'wifi', 'cellular', 'none', 'unknown', ...
    isConnected: netInfoState.isConnected === true, // true / false (null becomes false)
    isInternetReachable: netInfoState.isInternetReachable, // true / false / null (null = still checking)
    lastUpdated: new Date().toLocaleTimeString(),
  };
}

// ---------- Helper: friendly text for the connection type ----------
function getTypeLabel(type, isConnected) {
  if (!isConnected) {
    return 'No Connection';
  }
  switch (type) {
    case 'wifi':
      return 'Wi-Fi';
    case 'cellular':
      return 'Cellular (Mobile Data)';
    case 'ethernet':
      return 'Ethernet';
    case 'bluetooth':
      return 'Bluetooth';
    case 'vpn':
      return 'VPN';
    case 'wimax':
      return 'WiMAX';
    case 'other':
      return 'Other';
    default:
      return 'Unknown';
  }
}

// ---------- Helper: text + colour for the internet reachability line ----------
function getReachability(isConnected, isInternetReachable) {
  if (!isConnected) {
    return { text: 'Internet reachable: No', color: OFFLINE_COLOR };
  }
  if (isInternetReachable === true) {
    return { text: 'Internet reachable: Yes', color: ONLINE_COLOR };
  }
  if (isInternetReachable === false) {
    return {
      text: 'Internet reachable: No (connected to a network, but it has no internet)',
      color: OFFLINE_COLOR,
    };
  }
  // isInternetReachable is null -> NetInfo has not finished checking yet
  return { text: 'Internet reachable: Checking...', color: WARNING_COLOR };
}

export default function App() {
  // ----- State: the values shared by the indicator, the labels and the Refresh button -----
  const [isLoaded, setIsLoaded] = useState(false);
  const [type, setType] = useState('unknown');
  const [isConnected, setIsConnected] = useState(false);
  const [isInternetReachable, setIsInternetReachable] = useState(null);
  const [lastUpdated, setLastUpdated] = useState('');
  const [isRefreshing, setIsRefreshing] = useState(false);

  // Animation value for the "pulse" effect when the status changes
  const pulse = useRef(new Animated.Value(1)).current;

  // One function that stores a NetInfo state into our React state.
  // The initial check, the live listener and the Refresh button ALL use it.
  const applyNetInfoState = useCallback((netInfoState) => {
    const s = toScreenState(netInfoState);
    setType(s.type);
    setIsConnected(s.isConnected);
    setIsInternetReachable(s.isInternetReachable);
    setLastUpdated(s.lastUpdated);
    setIsLoaded(true);
  }, []);

  // ----- Initial snapshot + live listener (runs once, when the screen mounts) -----
  useEffect(() => {
    let isMounted = true;

    // 1. One-time snapshot of the current network state
    NetInfo.fetch()
      .then((netInfoState) => {
        if (isMounted) {
          applyNetInfoState(netInfoState);
        }
      })
      .catch((error) => {
        console.log('NetInfo.fetch failed:', error);
      });

    // 2. Live listener: called every time the network state changes
    const unsubscribe = NetInfo.addEventListener((netInfoState) => {
      if (isMounted) {
        applyNetInfoState(netInfoState);
      }
    });

    // 3. Cleanup: runs when the screen is closed (unmounted)
    return () => {
      isMounted = false;
      unsubscribe();
    };
  }, [applyNetInfoState]);

  // ----- Small pulse animation whenever the online/offline state or connection type changes -----
  useEffect(() => {
    if (!isLoaded) {
      return;
    }
    Animated.sequence([
      Animated.timing(pulse, { toValue: 1.15, duration: 150, useNativeDriver: true }),
      Animated.timing(pulse, { toValue: 1, duration: 150, useNativeDriver: true }),
    ]).start();
  }, [isConnected, type, isLoaded, pulse]);

  // ----- Manual Refresh button -----
  const handleRefresh = async () => {
    setIsRefreshing(true);
    try {
      // refresh() asks NetInfo to re-check the network (including internet reachability) right now
      const freshState = await NetInfo.refresh();
      applyNetInfoState(freshState);
    } catch (error) {
      console.log('NetInfo.refresh failed:', error);
    } finally {
      setIsRefreshing(false);
    }
  };

  // ----- Values used for drawing the screen -----
  const indicatorColor = isConnected ? ONLINE_COLOR : OFFLINE_COLOR;
  const statusText = isConnected ? 'ONLINE' : 'OFFLINE';
  const typeLabel = getTypeLabel(type, isConnected);
  const reachability = getReachability(isConnected, isInternetReachable);

  // ----- Screen -----
  return (
    <View style={styles.container}>
      <StatusBar style="dark" />

      {/* Title */}
      <Text style={styles.title}>Connectivity Status</Text>

      {!isLoaded ? (
        <View style={styles.loadingBox}>
          <ActivityIndicator size="large" color="#34495e" />
          <Text style={styles.loadingText}>Reading network state...</Text>
        </View>
      ) : (
        <View style={styles.center}>
          {/* Big coloured circle: green = online, red = offline */}
          <Animated.View
            style={[
              styles.circle,
              { backgroundColor: indicatorColor, transform: [{ scale: pulse }] },
            ]}
          >
            <Text style={styles.circleText}>{statusText}</Text>
          </Animated.View>

          {/* Connection type */}
          <Text style={styles.typeLabel}>Connection type: {typeLabel}</Text>

          {/* Internet reachability */}
          <Text style={[styles.reachability, { color: reachability.color }]}>
            {reachability.text}
          </Text>

          {/* Extra info */}
          <Text style={styles.info}>Last updated: {lastUpdated}</Text>
        </View>
      )}

      {/* Manual Refresh button */}
      <TouchableOpacity
        style={[styles.button, isRefreshing && styles.buttonDisabled]}
        onPress={handleRefresh}
        disabled={isRefreshing}
        activeOpacity={0.7}
      >
        <Text style={styles.buttonText}>{isRefreshing ? 'Refreshing...' : 'Refresh'}</Text>
      </TouchableOpacity>

      <Text style={styles.footer}>Running on: {Platform.OS}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f6fa',
    alignItems: 'center',
    paddingTop: 70,
    paddingBottom: 30,
    paddingHorizontal: 20,
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#2c3e50',
  },
  center: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  loadingBox: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  loadingText: {
    marginTop: 12,
    fontSize: 16,
    color: '#7f8c8d',
  },
  circle: {
    width: 190,
    height: 190,
    borderRadius: 95,
    alignItems: 'center',
    justifyContent: 'center',
    elevation: 6,
    shadowColor: '#000',
    shadowOpacity: 0.25,
    shadowRadius: 6,
    shadowOffset: { width: 0, height: 3 },
  },
  circleText: {
    color: '#ffffff',
    fontSize: 30,
    fontWeight: 'bold',
    letterSpacing: 2,
  },
  typeLabel: {
    marginTop: 36,
    fontSize: 20,
    fontWeight: '600',
    color: '#2c3e50',
    textAlign: 'center',
  },
  reachability: {
    marginTop: 12,
    fontSize: 16,
    fontWeight: '500',
    textAlign: 'center',
  },
  info: {
    marginTop: 12,
    fontSize: 14,
    color: '#7f8c8d',
  },
  button: {
    backgroundColor: '#2980b9',
    paddingVertical: 14,
    paddingHorizontal: 50,
    borderRadius: 30,
  },
  buttonDisabled: {
    backgroundColor: '#95a5a6',
  },
  buttonText: {
    color: '#ffffff',
    fontSize: 18,
    fontWeight: 'bold',
  },
  footer: {
    marginTop: 20,
    fontSize: 13,
    color: '#95a5a6',
  },
});