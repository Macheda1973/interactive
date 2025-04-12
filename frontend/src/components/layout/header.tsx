"use client"; // Add this line
import React, {useState, useEffect} from 'react';
import Link from 'next/link';

import { useRouter, usePathname } from "next/navigation";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faBars } from '@fortawesome/free-solid-svg-icons';
import Connect from '../connect';
import SideBar from '../sidebar';
import ConnectedWallet from '../connectedWallet';
export interface RouterProps {
    route: string;
}
const Header: React.FC = () => {

    const router = useRouter();
    const pathname = usePathname()
    const handleHome = () => {
        router.push("/");
    }
    const [isSideBar, setSideBar] = useState(false);
    const [isConnectedStatus, setIsConnectedStatus] = useState(0);


    const handeConnected =(value :number) => {
        setIsConnectedStatus(value);
    }
    const handeCloseConnected =() => {
        setIsConnectedStatus(0);
    }
    const handleSideBar = () => {
        setSideBar(prev => !prev);
    };
    const closeSideBr = () => {
        setSideBar(false);
    }


    const [isConnectOpen, setisConnectOpen] = useState<boolean>(false);

    const openConnect = () => setisConnectOpen(true);
    const closeConnect = () => setisConnectOpen(false);

    useEffect(() => {
        if (isSideBar) {
            document.body.classList.add('overflow-hidden'); // Add class to prevent scroll
        } else {
            document.body.classList.remove('overflow-hidden'); // Remove class to allow scroll
        }

        // Cleanup function to remove the class when component unmounts
        return () => {
            document.body.classList.remove('overflow-hidden');
        };
    }, [isSideBar]);

    return (
        <>
            <div className='container mx-auto  flex justify-between items-center p-3 px-[25px]'>
                <div className='flex flex-col items-center gap-2'>
                    <button onClick={handleHome}>
                        {/* <Image
                            src={`${isDarkMode ? "/assets/image/logo.png" : "/assets/image/light-logo.png"}`} 
                            alt="Logo Icon" 
                            width={140} // Set the desired width
                            height={40} // Set the desired height
                        /> */}
                        <div
                            className={`w-12 h-12 rounded-full bg-green-500 text-white flex items-center text-2xl justify-center font-bold`}
                        >
                            B
                        </div>
                    </button>
                    <div className='text-white'>{pathname === "/" ? "Affiliates": pathname === "partner" ? "Partner": "Portals"}</div>
                    
                </div>
                <div className="flex items-center justify-between" >
                    <div className="hidden md:block">
                        <div className="flex space-x-2 lg:space-x-6">
                            <Link href="/" className={`text-[14px] leading-[16.41px] ${pathname === "/" ? "text-green-default font-bold": "text-black dark:text-white font-normal "}`}>
                                Affiliates
                            </Link>
                            <Link href="/partner"  className={`text-[14px] leading-[16.41px] ${pathname === "/partner" ? "text-green-default font-bold": "text-black dark:text-white font-normal "}`}>
                                Partner
                            </Link>
                            <Link href="/portals" className={`text-[14px] leading-[16.41px] ${pathname === "/portals" ? "text-green-default font-bold": "text-black dark:text-white font-normal"}`}>
                                Portals
                            </Link>
                        </div>
                    </div>
                </div>
                <div className='flex space-x-3 lg:space-x-6 items-center '>
                    <button 
                        className='hidden md:block border border-green-default text-green-default font-[500] text-[18px] leading-[24px] py-[5px] px-[10px] rounded-[10px] w-[120px] hover:bg-green-default hover:text-white transition duration-200' 
                        onClick={() => handeConnected(1)}
                    >
                        Login
                    </button>
                    <button 
                        className='hidden md:block text-center border border-green-default bg-green-default  text-white dark:text-black  font-[500] text-[18px] leading-[24px] py-[5px] px-[10px] rounded-[10px] w-[120px] hover:text-green-default dark:hover:text-white hover:bg-opacity-0 transition duration-200' 
                        onClick={() => handeConnected(2)}
                    >
                        Sign
                    </button>
                    <button onClick={handleSideBar} className='items-center justify-center flex md:hidden'>
                        <FontAwesomeIcon 
                            icon={faBars} 
                            className="text-[24px] font-bold text-black dark:text-white" 
                        />
                    </button>
                </div>
            </div>
            <Connect  isOpen={isConnectOpen} onClose={closeConnect}></Connect>
            <ConnectedWallet isOpen={isConnectedStatus === 1 || isConnectedStatus === 2} isStatus={isConnectedStatus} onClose={handeCloseConnected}/>
            <SideBar isOpen={isSideBar}  onClose={closeSideBr} openConnect={openConnect} handeConnected={handeConnected}/>
        </>
    );
};
export default Header;