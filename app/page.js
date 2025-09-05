'use client'

import { useState, useEffect } from 'react'

export default function Home() {
  const [message, setMessage] = useState('Loading...')
  const [error, setError] = useState(null)

  useEffect(() => {
    const fetchMessage = async () => {
      try {
        const response = await fetch('/api/hello')
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`)
        }
        const data = await response.json()
        setMessage(data.message)
      } catch (err) {
        setError(err.message)
        setMessage('Failed to connect to backend')
      }
    }

    fetchMessage()
  }, [])

  return (
    <div className="container">
      <div className="main">
        <h1>🚀 Coolify Demo App</h1>
        <div className={`response-box ${error ? 'error' : 'success'}`}>
          <h2>Backend Response:</h2>
          <p style={{ fontSize: '18px', fontWeight: 'bold' }}>{message}</p>
          {error && <p style={{ color: '#f44336', fontSize: '14px' }}>Error: {error}</p>}
        </div>
        <p className="api-url">
          API URL: /api/hello (internal Next.js API route)
        </p>
        <p style={{ color: '#666', fontSize: '14px' }}>
          🎯 Single deployment with both frontend and backend!
        </p>
      </div>
    </div>
  )
}
