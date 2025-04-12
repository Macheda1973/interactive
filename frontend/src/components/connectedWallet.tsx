
"use client"; // Add this line
import React, {useState, useRef, useEffect} from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faClose} from '@fortawesome/free-solid-svg-icons';
import DefaultAnimation from "./layout/DefaultAnimation";
interface ConnectProps {
    isOpen: boolean;
    isStatus: number;
    onClose: () => void;
}
const ConnectedWallet: React.FC<ConnectProps> = ({ isOpen, isStatus, onClose }) => {

  const connectRef = useRef<HTMLDivElement | null>(null);
  const [isConnectedStatus, setIsConnectedStatus] = useState(0);

  useEffect(() => {
    setIsConnectedStatus(isStatus)
  }, [isStatus])

  const handleToggle = () => {
    if(isConnectedStatus === 1)
    {
        setIsConnectedStatus(2)
    }
    else
    {
        setIsConnectedStatus(1)
    }
  }
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
    (isOpen &&
    <div className={`absolute w-full h-[100vh] inset-0 bg-black bg-opacity-50 z-[1000]`}>
      <div ref={connectRef} className={`absolute flex justify-center items-center top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 px-[25px]`}>
      <DefaultAnimation>
        <div className="flex flex-col rounded-[15px] flex-wrap  w-[340px] sm:w-[490px] h-hit bg-white dark:bg-gray-dark p-[20px] sm:p-[35px] shadow-custom  border-[0.6px] border-gray-light dark:border-gray-default">
          <div className="flex flex-col gap-6">
            <div className="flex w-full relative">
                <p className="w-full text-[20px] font-bold leading-[23.41px] text-black dark:text-white py-2">
                
                </p>
                <button onClick={onClose}>
                    <FontAwesomeIcon 
                        icon={faClose} 
                        className="text-[18px] font-bold text-black dark:text-white absolute top-0 right-0" 
                    />
                </button>
            </div>
            <button
                onClick={handleToggle}
                className={`flex w-full bg-[#E4E4E4] dark:bg-[#3C3C3C] text-[#757575] dark:text-gray-light rounded-lg ${isConnectedStatus === 1 ? '' : 'nav-item-hide'}`}
                >
                <span className={`flex w-full justify-center rounded-lg p-2 px-4 ${isConnectedStatus === 1 ? 'bg-green-default border-1 border-green-default rounded-lg text-white dark:text-black' : ''}`}>Login</span>
                <span className={`flex w-full justify-center rounded-lg p-2 px-4 ${isConnectedStatus === 1 ? '' : 'bg-green-default border-1 border-green-default text-white dark:text-black'}`}>Sign</span>
            </button>
            {
                isConnectedStatus === 1 ? (
                    <>
                        <div className='flex justify-between w-full bg-[#E4E4E4] dark:bg-[#3C3C3C] text-[#757575] dark:text-gray-light rounded-lg p-[12px]'>
                            <p className='text-[13px] break-words w-10/12'>Name</p>
                        </div>
                        <div className='flex justify-between w-full bg-[#E4E4E4] dark:bg-[#3C3C3C] text-[#757575] dark:text-gray-light rounded-lg p-[12px]'>
                            <p className='text-[13px] break-words w-10/12'>Password</p>
                        </div>
                        <div className='flex justify-center'>
                            <button  className="bg-[#EF4444] font-[500] text-[18px] w-[200px] leading-[24px] py-[9px] px-[21px] rounded-full text-white">
                            Login
                            </button>
                        </div>
                    </>
                ) : (
                    <>
                    <div className='flex justify-between w-full bg-[#E4E4E4] dark:bg-[#3C3C3C] text-[#757575] dark:text-gray-light rounded-lg p-[12px]'>
                            <p className='text-[13px] break-words w-10/12'>Name</p>
                        </div>
                        <div className='flex justify-between w-full bg-[#E4E4E4] dark:bg-[#3C3C3C] text-[#757575] dark:text-gray-light rounded-lg p-[12px]'>
                            <p className='text-[13px] break-words w-10/12'>Password</p>
                        </div>
                        <div className='flex justify-center'>
                            <button  className="bg-[#EF4444] font-[500] text-[18px] w-[200px] leading-[24px] py-[9px] px-[21px] rounded-full text-white">
                            Sign
                            </button>
                        </div>
                    </>
                )
            }
            
          </div>
        </div>      
        </DefaultAnimation>
      </div>

    </div>
   
    )
  );
};

export default ConnectedWallet;