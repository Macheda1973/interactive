"use client"; // Add this line
import React from 'react';
import Header from "./header";
import Footer from "./footer";
import '../../language';
export default function DefaultLayout({
    children,
  }: {
    children: React.ReactNode;
  }) {
  return (
    <div className='h-screen bg-white dark:bg-[#16153D]'>
      <Header />
      <div className='bg-[#2b2b40]'>
      {children}
      </div>
      <Footer />
    </div>
  );
}
