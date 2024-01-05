<template>
  <div>
    <h1>Transactions</h1>

    <p v-if="errors.length">
      <b>Please correct the following error(s):</b>
      <ul>
        <li v-for="error in errors">{{ error }}</li>
      </ul>
    </p>

    <!-- Create or Post -->
    <input type="text"
      v-model="amount"
      placeholder="Amount"
      class="title-input" />
    <input type="text"
      v-model="description"
      placeholder="Description"
      class="body-input" />
    <input type="text"
      v-model="date"
      placeholder="Date"
      class="body-input" />

    <!-- only render if editing post -->
    <button v-if="isEditing" @click="updateTransaction">Update</button>

    <!-- only render if not editing post -->
    <button v-else="isEditing" @click="createTransaction">Create</button>

    <!-- List of Transactions -->
    <div v-for="transaction in transactions" :key="transaction.id">
      <h3>[{{ transaction.id }}] {{ transaction.description }}</h3>
      <p>{{ transaction.amount }}</p>
      <p>{{ new Date(transaction.date).toLocaleDateString() }}</p>

      <button @click="editTransaction(transaction.id)">Edit</button>
      <button @click="deleteTransaction(transaction.id)">Delete</button>
    </div>
  </div>
</template>

<script setup>
  import { ref, onMounted } from 'vue';

  const transactions = ref([])
  const errors = ref([])

  const amount = ref(0)
  const description = ref('')
  const date = ref('')
  const transaction_id = ref(0)
  const isEditing = ref(false)
  const API_URL = "http://localhost:3000/transactions"

  onMounted(async() => {
    const res = await fetch(API_URL)
    transactions.value = await res.json()
  })

  const grabErrors = () => {
    errors.value = []
    if(amount.value === '') {
      errors.value.push('Amount is required')
    } 
    if(amount.value === 0) {
      errors.value.push('Amount is required')
    }
    if(description.value === '') {
      errors.value.push('Description is required')
    } 
    if(date.value === '') {
      errors.value.push('Date is required')
    }
  }

  const createTransaction = async() => {
    grabErrors()
    if(errors.value.length > 0) {
      return
    }

    const res = await fetch(API_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        amount: amount.value,
        description: description.value,
        date: date.value
      })
    })

    const data = await res.json()

    transactions.value.push(data)

    amount.value = 0
    description.value = ''
    date.value = ''
    transaction_id.value = 0
  }

  const updateTransaction = async() => {
    grabErrors()
    if(errors.value.length > 0) {
      return
    }

    const res = await fetch(`${API_URL}/${transaction_id.value}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        amount: amount.value,
        description: description.value,
        date: date.value
      })
    })

    const data = await res.json()

    const index = transactions.value.findIndex(transaction => transaction.id === data.id)
    transactions.value[index] = data

    amount.value = 0
    description.value = ''
    date.value = ''
    transaction_id.value = 0
    isEditing.value = false
  }

  const deleteTransaction = async(id) => {
    await fetch (`${API_URL}/${id}`, {
      method: 'DELETE'
    })
    transactions.value = transactions.value.filter(transaction => transaction.id !== id)
  }

  const editTransaction = async(id) => {
    const transaction = transactions.value.find(transaction => transaction.id === id)
    amount.value = transaction.amount
    description.value = transaction.description
    date.value = transaction.date
    transaction_id.value = transaction.id
    isEditing.value = true
    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    })
  }
</script>

<style scoped>
.title-input {
    width: 100%;
    padding: 12px 20px;
    margin: 8px 0;
    box-sizing: border-box;
    border: 2px solid #ccc;
    background-color: #f8f8f8;
    color: #111;
    border-radius: 4px;
    resize: vertical;
}

.body-input {
    width: 100%;
    padding: 12px 20px;
    margin: 8px 0;
    box-sizing: border-box;
    border: 2px solid #ccc;
    background-color: #f8f8f8;
    color: #111;
    border-radius: 4px;
    resize: vertical;
}
</style>
