import type { Action, ThunkAction } from '@reduxjs/toolkit'
import { configureStore } from '@reduxjs/toolkit'
import { createWrapper } from 'next-redux-wrapper'
import { DEBUG } from '@/config'
import { appSlice } from './appSlice'
import { accountSlice } from './accountSlice'

const makeStore = () =>
  configureStore({
    reducer: {
      app: appSlice.reducer,
      account: accountSlice.reducer,
    },
    devTools: DEBUG,
  })

export type AppStore = ReturnType<typeof makeStore>
export type AppState = ReturnType<AppStore['getState']>
export type AppDispatch = AppStore['dispatch']
export type AppThunk<ReturnType = void> = ThunkAction<ReturnType, AppState, unknown, Action>

export const wrapper = createWrapper<AppStore>(makeStore, { debug: DEBUG })
export default wrapper
