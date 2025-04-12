"use client"; // Add this line
import React, {useState} from 'react';
import Connect from '@/components/connect';
import DefaultAnimation from '@/components/layout/DefaultAnimation';

export default function Home() {
    const [isConnectOpen, setConnectOpen] = useState<boolean>(false);
    const closeConnect = () => setConnectOpen(false);

  return (
    <div className="container mx-auto flex flex-col main-container py-[20px] md:py-[50px] px-[25px]">
      <DefaultAnimation>
      <div className="flex flex-col md:flex-row justify-between mt-10 w-full items-center">
        <div className="w-7/12 flex flex-col h-full space-y-3 md:space-y-10 py-5 md:py-10 w-full">
          <p className="text-[30px] md:text-[89px] font-[600] leading-[40px] md:leading-[105px] text-black dark:text-white">
            Welcome to Our Site
          </p>
          <p className="text-[18px] md:text-[30px] font-normal leading-[35px] text-gray-light">
            This is <span className='text-green-default'>Partner</span> page
          </p>
        </div>
      </div>
      </DefaultAnimation>
      <Connect  isOpen={isConnectOpen} onClose={closeConnect}></Connect>
    </div>
  );
}
