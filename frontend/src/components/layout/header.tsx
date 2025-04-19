"use client";
import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { useRouter, usePathname } from "next/navigation";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faBars } from '@fortawesome/free-solid-svg-icons';

import Connect from '../connect';
import SideBar from '../sidebar';
import ConnectedWallet from '../connectedWallet';

const Header: React.FC = () => {
    const router = useRouter();
    const pathname = usePathname();
    
    const [isSideBar, setSideBar] = useState(false);
    const [isConnectedStatus, setIsConnectedStatus] = useState(0);
    const [isLoggedIn] = useState<boolean>(false);
    const [isConnectOpen, setIsConnectOpen] = useState<boolean>(false);

    const handleHome = () => router.push("/");
    const handeConnected = (value: number) => setIsConnectedStatus(value);
    const handeCloseConnected = () => setIsConnectedStatus(0);
    const handleSideBar = () => setSideBar(prev => !prev);
    const closeSideBr = () => setSideBar(false);
    const openConnect = () => setIsConnectOpen(true);
    const closeConnect = () => setIsConnectOpen(false);

    useEffect(() => {
        if (isSideBar) document.body.classList.add('overflow-hidden');
        else document.body.classList.remove('overflow-hidden');
        return () => document.body.classList.remove('overflow-hidden');
    }, [isSideBar]);

    const handleUserClick = () => {
        isLoggedIn ? router.push("/user") : handeConnected(1);
    };

    return (
        <>
            <div className='w-full flex items-center justify-between px-4 py-2 md:px-16 md:py-4 h-[10vh] md:h-[15vh] dark:bg-[#16153D]'>
                <div className='flex flex-col items-start xl:items-center justify-start'>
                    <button onClick={handleHome}>
                        <div className='w-12 h-12 text-black dark:text-white flex items-center text-3xl justify-center font-bold'>
                            ICL
                        </div>
                    </button>
                    <div className='text-white text-base xl:text-lg font-semibold hidden md:block'>
                        Interactive Companies Ltd
                    </div>
                </div>

                <div className="hidden md:flex overflow-x-auto">
                    <div className="flex items-center space-x-6 lg:space-x-10 min-w-[700px]">
                        <div className='flex flex-col bg-[#002345] px-6 py-4 rounded-lg min-w-[300px]'>
                            <div className='flex justify-between gap-8 whitespace-nowrap'>
                                <Link href="/partner" className={`text-sm md:text-base font-semibold ${pathname === "/partner" ? "text-green-default font-bold" : "text-white font-normal"}`}>
                                    Partner
                                </Link>
                                <Link href="/portals" className={`text-sm md:text-base font-semibold ${pathname === "/portals" ? "text-green-default font-bold" : "text-white font-normal"}`}>
                                    Partner Portal
                                </Link>
                                <Link href="/" className={`text-sm md:text-base font-semibold ${pathname === "/" ? "text-green-default font-bold" : "text-white font-normal"}`}>
                                    Affiliate
                                </Link>
                            </div>
                            <div className="flex justify-between mt-2 text-white text-xs md:text-sm whitespace-nowrap">
                                <div>Become our Partner</div>
                                <div>Connect to the future</div>
                            </div>
                        </div>

                        <button onClick={handleUserClick} className={`whitespace-nowrap text-sm md:text-base font-semibold ${pathname === "/user" ? "text-green-default font-bold" : "text-black dark:text-white font-normal"}`}>
                            User
                        </button>
                        <Link href="/info" className={`whitespace-nowrap text-sm md:text-base font-semibold ${pathname === "/info" ? "text-green-default font-bold" : "text-black dark:text-white font-normal"}`}>
                            Who we are
                        </Link>
                        <Link href="/service" className={`whitespace-nowrap text-sm md:text-base font-semibold ${pathname === "/service" ? "text-green-default font-bold" : "text-black dark:text-white font-normal"}`}>
                            Our Services
                        </Link>
                    </div>
                </div>

                <div className='flex gap-2 items-center justify-end'>
                    <button
                        className='hidden md:block border border-green-default text-green-default font-medium text-sm md:text-base py-1 px-3 rounded-[10px] w-[100px] hover:bg-green-default hover:text-white transition'
                        onClick={() => handeConnected(1)}
                    >
                        Login
                    </button>
                    <button
                        className='hidden md:block border border-green-default bg-green-default text-white dark:text-black font-medium text-sm md:text-base py-1 px-3 rounded-[10px] w-[100px] hover:bg-opacity-0 hover:text-green-default dark:hover:text-white transition'
                        onClick={() => handeConnected(2)}
                    >
                        Sign Up
                    </button>
                    <button onClick={handleSideBar} className='md:hidden flex items-center justify-center'>
                        <FontAwesomeIcon icon={faBars} className="text-2xl text-black dark:text-white" />
                    </button>
                </div>
            </div>

            <Connect isOpen={isConnectOpen} onClose={closeConnect} />
            <ConnectedWallet
                isOpen={isConnectedStatus === 1 || isConnectedStatus === 2}
                isStatus={isConnectedStatus}
                onClose={handeCloseConnected}
            />
            <SideBar
                isOpen={isSideBar}
                onClose={closeSideBr}
                openConnect={openConnect}
                handeConnected={handeConnected}
            />
        </>
    );
};

export default Header;
