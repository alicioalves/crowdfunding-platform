/* eslint-disable */
import web3 from './web3'

const address = process.env.ETH_ADDRESS

const abi = [
  [
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: 'address',
          name: 'contractAddress',
          type: 'address'
        },
        {
          indexed: false,
          internalType: 'address',
          name: 'projectStarted',
          type: 'address'
        },
        {
          indexed: false,
          internalType: 'string',
          name: 'projectTitle',
          type: 'string'
        },
        {
          indexed: false,
          internalType: 'string',
          name: 'ProjectDesc',
          type: 'string'
        },
        {
          indexed: false,
          internalType: 'uint256',
          name: 'deadline',
          type: 'uint256'
        },
        {
          indexed: false,
          internalType: 'uint256',
          name: 'goalAmount',
          type: 'uint256'
        }
      ],
      name: 'ProjectStarted',
      type: 'event'
    },
    {
      inputs: [
        {
          internalType: 'string',
          name: 'title',
          type: 'string'
        },
        {
          internalType: 'string',
          name: 'description',
          type: 'string'
        },
        {
          internalType: 'uint256',
          name: 'durationInDays',
          type: 'uint256'
        },
        {
          internalType: 'uint256',
          name: 'amountToRaise',
          type: 'uint256'
        }
      ],
      name: 'startProject',
      outputs: [],
      stateMutability: 'nonpayable',
      type: 'function'
    },
    {
      inputs: [],
      name: 'returnAllProjects',
      outputs: [
        {
          internalType: 'contract Project[]',
          name: '',
          type: 'address[]'
        }
      ],
      stateMutability: 'view',
      type: 'function'
    }
  ]
]

const instance = new web3.eth.Contract(abi, address)

export default instance
