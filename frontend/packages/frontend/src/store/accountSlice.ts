import { createSlice, PayloadAction } from '@reduxjs/toolkit'

interface SliceState {
  address: string | null
  balance: string | null
  publicKey: string | null
}

const initialState: SliceState = {
  address: null,
  balance: null,
  publicKey: null,
}

const slice = createSlice({
  name: 'account',

  initialState,

  reducers: {
    setAddress(state, action: PayloadAction<string | null>) {
      state.address = action.payload
    },
    setBalance(state, action: PayloadAction<string | null>) {
      state.balance = action.payload
    },
    setPublicKey(state, action: PayloadAction<string | null>) {
      state.publicKey = action.payload
    },
  },
})

export const accountSlice = slice
