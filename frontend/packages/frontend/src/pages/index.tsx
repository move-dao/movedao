import type { NextPage } from 'next'
import Connect from '@/components/Connect'

const Home: NextPage = () => {
  return (
    <>
      <h1>Welcome to MoveDAO</h1>
      <Connect />
    </>
  )
}

export default Home
