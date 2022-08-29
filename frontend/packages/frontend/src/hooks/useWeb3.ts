import { useWeb3 as useFewchaWeb3 } from '@fewcha/web3-react'
import { useEffect } from 'react'
import { useAppDispatch } from '@/hooks/index'
import { accountSlice } from '@/store/accountSlice'
import { appSlice } from '@/store/appSlice'

const useWeb3 = () => {
  const result = useFewchaWeb3()
  const dispatch = useAppDispatch()

  useEffect(() => {
    if (result.account?.address) {
      dispatch(accountSlice.actions.setAddress(result.account.address))
    }
  }, [result.account?.address])

  useEffect(() => {
    if (result.account?.publicKey) {
      dispatch(accountSlice.actions.setPublicKey(result.account.publicKey))
    }
  }, [result.account?.publicKey])

  useEffect(() => {
    if (result.balance) {
      dispatch(accountSlice.actions.setBalance(result.balance))
    }
  }, [result.balance])

  useEffect(() => {
    if (result.network) {
      dispatch(appSlice.actions.setNetwork(result.network))
    }
  }, [result.network])

  return result
}

export default useWeb3
