import React from 'react';
const Footer: React.FC = () => {
    return (
        <div className=' w-full bg-white dark:bg-[#16153D] shadow-custom-green py-[15px] px-[25px] h-[15vh]'>
            <div className='container mx-auto flex flex-col md:flex-row  justify-between items-center space-y-1 relative'>
                <div className='flex flex-col gap-2 w-full  items-center md:items-start justify-center'>
                    <p className="text-[14px] font-bold leading-[16.41px] text-white">
                        INTERACTIVE COMPANIES LIMITED:
                    </p>
                    <p className="text-[12px] font-normal leading-[16.41px] text-gray-light text-right">
                        128, City Road, London, EC1V 2NX, UNITED KINGDOM
                    </p>
                    <p className="text-[12px] font-normal leading-[16.41px] text-gray-light">
                        Company Number: 16357095
                    </p>
                </div>
                <p className="flex w-full justify-center text-[14px] text-center font-[300] leading-[30px] text-gray-light dark:text-white ">
                    © 2025 Our Company
                </p>
                <div className="flex flex-col gap-2 w-full  items-center md:items-end justify-center">
                    <p className="text-[14px] font-normal leading-[16.41px] text-gray-light text-center">
                        Financial partner logos
                    </p>
                    <p className="text-[14px] font-normal leading-[16.41px] text-gray-light">
                        Privacy
                    </p>
                    <p className="text-[14px] font-normal leading-[16.41px] text-gray-light">
                        Cookies 
                    </p>
                </div>
            </div>
        </div>
    );
};
export default Footer;