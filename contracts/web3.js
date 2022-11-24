/* eslint-disable */
import Web3 from 'web3'

if (window.ethereum) {
  window.web3 = new Web3(ethereum)
  try {
    // Request account access if needed
    ethereum.enable()
  } catch (error) {
    console.log(error)
  }
} else if (window.web3) {
  // Legacy dapp browser
  window.web3 = new Web3(web3.currentProvider)
} else {
  // Non-dapp browsers
  console.log(
    'Non-Ethereum browser detected. You should consider trying MetaMask!'
  )
}

export default web3
