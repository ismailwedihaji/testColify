import { NextResponse } from 'next/server'

export async function GET() {
  try {
    return NextResponse.json({
      message: "Hello from Coolify backend 🚀",
      timestamp: new Date().toISOString(),
      env: process.env.NODE_ENV || 'development',
      deployment: 'single-app'
    })
  } catch (error) {
    return NextResponse.json(
      { error: 'Internal Server Error' },
      { status: 500 }
    )
  }
}
