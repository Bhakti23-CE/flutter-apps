import React, { useState } from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  FlatList,
  SafeAreaView,
  StyleSheet,
  Alert,
  Platform,
} from 'react-native';

const CATEGORIES = ['Food', 'Travel', 'Shopping', 'Bills', 'Other'];

/*  1. SummaryCard  */
function SummaryCard({ balance, income, expense }) {
  return (
    <View style={styles.summaryCard}>
      <Text style={styles.summaryLabel}>Total Balance</Text>
      <Text style={styles.balanceText}>₹{balance.toFixed(2)}</Text>

      <View style={styles.summaryRow}>
        <View style={styles.summaryBox}>
          <Text style={styles.summaryLabel}>Income</Text>
          <Text style={[styles.summaryAmount, styles.green]}>
            ₹{income.toFixed(2)}
          </Text>
        </View>
        <View style={styles.summaryBox}>
          <Text style={styles.summaryLabel}>Expense</Text>
          <Text style={[styles.summaryAmount, styles.red]}>
            ₹{expense.toFixed(2)}
          </Text>
        </View>
      </View>
    </View>
  );
}

/*  2. CategoryChip  */
function CategoryChip({ label, selected, onPress }) {
  return (
    <TouchableOpacity
      onPress={onPress}
      style={[styles.chip, selected && styles.chipSelected]}
    >
      <Text style={[styles.chipText, selected && styles.chipTextSelected]}>
        {label}
      </Text>
    </TouchableOpacity>
  );
}

/*  3. AddForm  */
function AddForm({ onAdd }) {
  // Local state: AddForm remembers its own input values
  const [title, setTitle] = useState('');
  const [amount, setAmount] = useState('');
  const [type, setType] = useState('income');
  const [category, setCategory] = useState('Other');

  const handleSubmit = () => {
    const numericAmount = Number(amount);

    // Validation: title not empty, amount must be a positive number
    if (title.trim() === '' || isNaN(numericAmount) || numericAmount <= 0) {
      if (Platform.OS === 'web') {
        window.alert(
          'Invalid input\n\nPlease enter a title and an amount greater than 0.'
        );
      } else {
        Alert.alert(
          'Invalid input',
          'Please enter a title and an amount greater than 0.'
        );
      }

      return;
    }

    // Send the new transaction up to App using the onAdd prop
    onAdd({
      id: Date.now().toString(), // unique ID
      title: title.trim(),
      amount: numericAmount,
      type: type,
      category: category,
    });

    // Reset the form
    setTitle('');
    setAmount('');
    setType('income');
    setCategory('Other');
  };

  return (
    <View style={styles.form}>
      <Text style={styles.formHeading}>Add Transaction</Text>

      {/* Income / Expense selector */}
      <View style={styles.typeRow}>
        <TouchableOpacity
          style={[
            styles.typeButton,
            type === 'income' && styles.typeIncomeActive,
          ]}
          onPress={() => setType('income')}
        >
          <Text
            style={[
              styles.typeText,
              type === 'income' && styles.typeTextActive,
            ]}
          >
            Income
          </Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={[
            styles.typeButton,
            type === 'expense' && styles.typeExpenseActive,
          ]}
          onPress={() => setType('expense')}
        >
          <Text
            style={[
              styles.typeText,
              type === 'expense' && styles.typeTextActive,
            ]}
          >
            Expense
          </Text>
        </TouchableOpacity>
      </View>

      <TextInput
        style={styles.input}
        placeholder="Title (e.g. Lunch)"
        value={title}
        onChangeText={setTitle}
      />

      <TextInput
        style={styles.input}
        placeholder="Amount"
        keyboardType="numeric"
        value={amount}
        onChangeText={setAmount}
      />

      <Text style={styles.chipHeading}>Category</Text>
      <View style={styles.chipRow}>
        {CATEGORIES.map((cat) => (
          <CategoryChip
            key={cat}
            label={cat}
            selected={category === cat}
            onPress={() => setCategory(cat)}
          />
        ))}
      </View>

      <TouchableOpacity style={styles.addButton} onPress={handleSubmit}>
        <Text style={styles.addButtonText}>Add Transaction</Text>
      </TouchableOpacity>
    </View>
  );
}

/*  4. TransactionItem  */
function TransactionItem({ item, onDelete }) {
  const isIncome = item.type === 'income';

  return (
    <View style={styles.item}>
      <View style={styles.itemInfo}>
        <Text style={styles.itemTitle}>{item.title}</Text>
        <Text style={styles.itemCategory}>{item.category}</Text>
      </View>

      <Text style={[styles.itemAmount, isIncome ? styles.green : styles.red]}>
        {isIncome ? '+' : '-'}₹{item.amount.toFixed(2)}
      </Text>

      <TouchableOpacity
        style={styles.deleteButton}
        onPress={() => onDelete(item.id)}
      >
        <Text style={styles.deleteText}>Delete</Text>
      </TouchableOpacity>
    </View>
  );
}

/*  5. App (root component)  */
export default function App() {
  const [transactions, setTransactions] = useState([]);

  const addTransaction = (transaction) => {
    setTransactions([transaction, ...transactions]);
  };

  const deleteTransaction = (id) => {
    setTransactions(transactions.filter((t) => t.id !== id));
  };

  // Totals calculated with filter() and reduce()
  const totalIncome = transactions
    .filter((t) => t.type === 'income')
    .reduce((sum, t) => sum + t.amount, 0);

  const totalExpense = transactions
    .filter((t) => t.type === 'expense')
    .reduce((sum, t) => sum + t.amount, 0);

  const balance = totalIncome - totalExpense;

  return (
    <SafeAreaView style={styles.container}>
      <Text style={styles.appTitle}>Expense Manager</Text>

      <FlatList
        data={transactions}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => (
          <TransactionItem item={item} onDelete={deleteTransaction} />
        )}
        ListHeaderComponent={
          <View>
            <SummaryCard
              balance={balance}
              income={totalIncome}
              expense={totalExpense}
            />
            <AddForm onAdd={addTransaction} />
            <Text style={styles.listHeading}>Transactions</Text>
          </View>
        }
        ListEmptyComponent={
          <Text style={styles.emptyText}>No transactions yet.</Text>
        }
        keyboardShouldPersistTaps="handled"
        contentContainerStyle={styles.listContent}
      />
    </SafeAreaView>
  );
}

/*  Styles (Flexbox layout)  */
const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f2f4f8', paddingTop: 30 },
  appTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    textAlign: 'center',
    marginVertical: 12,
  },
  listContent: { paddingHorizontal: 16, paddingBottom: 40 },

  green: { color: '#2e7d32' },
  red: { color: '#c62828' },

  summaryCard: {
    backgroundColor: '#ffffff',
    borderRadius: 12,
    padding: 16,
    marginBottom: 16,
    elevation: 3,
    alignItems: 'center',
  },
  summaryLabel: { fontSize: 14, color: '#666' },
  balanceText: { fontSize: 32, fontWeight: 'bold', marginVertical: 6 },
  summaryRow: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    alignSelf: 'stretch',
    marginTop: 8,
  },
  summaryBox: { alignItems: 'center' },
  summaryAmount: { fontSize: 18, fontWeight: 'bold' },

  form: {
    backgroundColor: '#ffffff',
    borderRadius: 12,
    padding: 16,
    marginBottom: 16,
    elevation: 3,
  },
  formHeading: { fontSize: 18, fontWeight: 'bold', marginBottom: 10 },
  typeRow: { flexDirection: 'row', marginBottom: 10 },
  typeButton: {
    flex: 1,
    paddingVertical: 10,
    borderWidth: 1,
    borderColor: '#ccc',
    alignItems: 'center',
    marginHorizontal: 4,
    borderRadius: 8,
  },
  typeIncomeActive: { backgroundColor: '#2e7d32', borderColor: '#2e7d32' },
  typeExpenseActive: { backgroundColor: '#c62828', borderColor: '#c62828' },
  typeText: { fontWeight: '600', color: '#333' },
  typeTextActive: { color: '#ffffff' },

  input: {
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 8,
    padding: 10,
    marginBottom: 10,
    backgroundColor: '#fafafa',
  },
  chipHeading: { fontWeight: '600', marginBottom: 6 },
  chipRow: { flexDirection: 'row', flexWrap: 'wrap', marginBottom: 12 },
  chip: {
    paddingVertical: 6,
    paddingHorizontal: 14,
    borderRadius: 20,
    borderWidth: 1,
    borderColor: '#999',
    marginRight: 8,
    marginBottom: 8,
  },
  chipSelected: { backgroundColor: '#1976d2', borderColor: '#1976d2' },
  chipText: { color: '#333' },
  chipTextSelected: { color: '#ffffff', fontWeight: 'bold' },

  addButton: {
    backgroundColor: '#1976d2',
    paddingVertical: 12,
    borderRadius: 8,
    alignItems: 'center',
  },
  addButtonText: { color: '#ffffff', fontWeight: 'bold', fontSize: 16 },

  listHeading: { fontSize: 18, fontWeight: 'bold', marginBottom: 8 },
  item: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#ffffff',
    padding: 12,
    borderRadius: 10,
    marginBottom: 8,
    elevation: 2,
  },
  itemInfo: { flex: 1 },
  itemTitle: { fontSize: 16, fontWeight: '600' },
  itemCategory: { fontSize: 12, color: '#777', marginTop: 2 },
  itemAmount: { fontSize: 16, fontWeight: 'bold', marginHorizontal: 10 },
  deleteButton: {
    backgroundColor: '#c62828',
    paddingVertical: 6,
    paddingHorizontal: 10,
    borderRadius: 6,
  },
  deleteText: { color: '#ffffff', fontWeight: 'bold', fontSize: 12 },

  emptyText: {
    textAlign: 'center',
    color: '#888',
    marginTop: 20,
    fontSize: 16,
  },
});