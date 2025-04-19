"use client"; // Add this line
import React from 'react';
import Script from 'next/script';
import Header from "./header";
import Footer from "./footer";
import '../../language';
import CookieBanner from '../CookieBanner';

export default function DefaultLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className='h-screen w-full bg-white flex flex-col  justify-between items-center'>
      <Script
        strategy="afterInteractive"
        src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"
      />
      <Script
        id="google-analytics"
        strategy="afterInteractive"
      >
        {`
          window.dataLayer = window.dataLayer || [];
          function gtag(){dataLayer.push(arguments);}
          gtag('js', new Date());
          gtag('config', 'G-XXXXXXXXXX');
        `}
      </Script>
      <Header />
      <div className='bg-[#2b2b40] w-full h-full'>
        {children}
      </div>
      <CookieBanner />
      <Footer />
    </div>
  );
}
