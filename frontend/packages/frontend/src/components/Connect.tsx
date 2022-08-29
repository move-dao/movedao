import { ConnectWallet } from '@fewcha/web3-react'
import useWeb3 from '@/hooks/useWeb3'
import { useAppSelector } from '@/hooks'

export default function Connect() {
  const { isConnected, disconnect } = useWeb3()
  const app = useAppSelector((state) => state.app)
  const account = useAppSelector((state) => state.account)

  return isConnected ? (
    <div>
      address: {account.address}
      <br />
      balance: {account.balance}
      <br />
      network: {app.network}
      <br />
      <button onClick={() => disconnect()}>Disconnect</button>
    </div>
  ) : (
    <ConnectWallet theme={'light'} label={<span>Connect</span>} />
  )
}
