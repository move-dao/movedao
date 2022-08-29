import { createSlice, PayloadAction } from '@reduxjs/toolkit'
import { HYDRATE } from 'next-redux-wrapper'
import { INITIAL_APP_NAME } from '@/config'

interface SliceState {
  name: string
  network: string | null
}

const initialState: SliceState = {
  name: INITIAL_APP_NAME,
  network: null,
}

const slice = createSlice({
  name: 'app',

  initialState,

  reducers: {
    setNetwork(state, action: PayloadAction<string | null>) {
      state.network = action.payload
    },
  },

  extraReducers: {
    [HYDRATE]: (state, action) => {
      return {
        ...state,
        ...action.payload.app,
      }
    },
  },
})

export const appSlice = slice
