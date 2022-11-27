/* eslint-disable */
const Web3 = require('web3')

const web3 = new Web3(ethereum || 'ws://localhost:8546')

try {
  // Request account access if needed
  ethereum.enable()
} catch (error) {
  console.log(error)
}

export default web3
