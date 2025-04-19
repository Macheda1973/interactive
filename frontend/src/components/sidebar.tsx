"use client"; // Add this line
import React, { useEffect, useRef } from "react";
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faClose } from '@fortawesome/free-solid-svg-icons';
import { usePathname } from "next/navigation";
import Link from 'next/link';
interface ConnectProps {
    isOpen: boolean;
    onClose: () => void;
    openConnect: () => void;
    handeConnected: (value: number) => void;
}

const SideBar: React.FC<ConnectProps> = ({ isOpen, onClose, handeConnected }) => {

    const pathname = usePathname()
    const connectRef = useRef<HTMLDivElement | null>(null);
    useEffect(() => {
        const handleClickOutside = (event: MouseEvent) => {
            if (connectRef.current && !connectRef.current.contains(event.target as Node)) {
                onClose();
            }
        };
        document.addEventListener('mousedown', handleClickOutside);
        return () => {
            document.removeEventListener('mousedown', handleClickOutside);
        };
    }, [onClose]);

    return (
        <>
            {isOpen &&
                (<div className={`absolute w-full h-[100vh] inset-0 bg-black bg-opacity-50 z-50`}>
                    <div ref={connectRef} className={`absolute h-full w-[320px] bg-[#002345] flex flex-col top-0 left-0 py-[15px] px-[18px] space-y-3`}>
                        <div className="flex justify-between items-center">
                            <div className={`w-12 h-12 text-black dark:text-white flex items-center text-3xl justify-center font-bold px-8`}>
                                ICL
                            </div>
                            <div className="flex justify-end">
                                <button onClick={onClose}>
                                    <FontAwesomeIcon
                                        icon={faClose}
                                        className="text-[28px] font-extrabold text-black dark:text-white"
                                    />
                                </button>
                            </div>
                        </div>
                        <div className="flex flex-col gap-1">
                            <Link onClick={onClose} href="/partner" className={`flex p-2 px-5 font-semibold text-lg rounded-lg dark:text-white  ${pathname === "/partner" ? "bg-light-light dark:bg-gray-default" : ""}`}>Partner</Link>
                            <Link onClick={onClose} href="/portals" className={`flex p-2 px-5  font-semibold text-lg rounded-lg dark:text-white  ${pathname === "/portals" ? "bg-light-light dark:bg-gray-default" : ""}`}>Portal</Link>
                            <Link onClick={onClose} href="/" className={`flex p-2 px-5  font-semibold text-lg rounded-lg dark:text-white ${pathname === "/" ? "bg-light-light dark:bg-gray-default" : ""}`}>Affiliate</Link>

                            <Link onClick={onClose} href="/user" className={`flex p-2 px-5  font-semibold text-lg rounded-lg dark:text-white  ${pathname === "/user" ? "bg-light-light dark:bg-gray-default" : ""}`}>User</Link>
                            <Link onClick={onClose} href="/info" className={`flex p-2 px-5  font-semibold text-lg rounded-lg dark:text-white  ${pathname === "/info" ? "bg-light-light dark:bg-gray-default" : ""}`}>Who we are</Link>
                            <Link onClick={onClose} href="/service" className={`flex p-2 px-5  font-semibold text-lg rounded-lg dark:text-white  ${pathname === "/service" ? "bg-light-light dark:bg-gray-default" : ""}`}>Our Services</Link>
                        </div>
                        <div className="h-full"></div>
                        <div className="flex justify-center items-center gap-4 ">
                            <button
                                className='border border-green-default text-green-default font-[500] text-[18px] leading-[24px] py-[5px] px-[10px] rounded-[10px] w-[120px] hover:bg-green-default hover:text-white transition duration-200'
                                onClick={() => {
                                    handeConnected(1);
                                    onClose();
                                }}
                            >
                                Login
                            </button>
                            <button
                                className='text-center border border-green-default bg-green-default  text-white dark:text-black  font-[500] text-[18px] leading-[24px] py-[5px] px-[10px] rounded-[10px] w-[120px] hover:text-green-default dark:hover:text-white hover:bg-opacity-0 transition duration-200'
                                onClick={() => {
                                    handeConnected(2);
                                    onClose();
                                }}
                            >
                                Sign Up
                            </button>
                        </div>
                    </div>
                </div>)}
        </>
    );
};

export default SideBar;