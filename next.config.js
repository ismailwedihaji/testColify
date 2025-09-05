/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone',
  // Disable telemetry
  telemetry: false,
  // Optimize for production
  compress: true,
  // Enable SWC minification
  swcMinify: true
}

module.exports = nextConfig
