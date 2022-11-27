/* eslint-disable */
const Web3 = require('web3')

const web3 = new Web3(ethereum || 'ws://localhost:8546')

try {
  // Request account access from a application like Status, Mist or Metamask if needed
  web3.eth.requestAccounts()
} catch (error) {
  console.log(error)
}

export default web3
