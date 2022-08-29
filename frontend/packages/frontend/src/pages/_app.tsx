import type { AppProps } from 'next/app'
import dynamic from 'next/dynamic'
import wrapper from '@/store'
import Head from 'next/head'
import { useAppSelector } from '@/hooks'

const Web3Provider = dynamic(() => import('@fewcha/web3-react'), { ssr: false })

function App({ Component, pageProps }: AppProps) {
  const appName = useAppSelector((state) => state.app.name)
  return (
    <Web3Provider>
      <Head>
        <title>{appName}</title>
        <meta name="viewport" content="initial-scale=1, width=device-width" />
      </Head>
      <Component {...pageProps} />
    </Web3Provider>
  )
}

export default wrapper.withRedux(App)
