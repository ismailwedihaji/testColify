import './globals.css'

export const metadata = {
  title: 'Coolify Demo App',
  description: 'Full-stack Next.js app for Coolify deployment demo',
}

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
