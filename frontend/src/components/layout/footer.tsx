import React from 'react';
const Footer: React.FC = () => {
    return (
        <div className=' w-full bg-white dark:bg-black shadow-custom-green py-[15px] px-[25px]'>
            <div className='container mx-auto flex flex-col md:flex-row  justify-between items-center space-y-1 relative'>
                <div className='flex  w-full justify-center md:justify-start items-center space-x-1'>
                    <p className="text-[14px] font-normal leading-[16.41px] text-gray-light">
                        INTERACTIVE COMPANIES LIMITED
                    </p>
                </div>
                <p className="flex w-full justify-center text-[14px] text-center font-[300] leading-[30px] text-gray-light dark:text-white ">
                    © 2024 Our Company
                </p>
                <div className="flex flex-col gap-2 w-full  items-center md:items-end justify-center">
                    <p className="text-[14px] font-normal leading-[16.41px] text-gray-light text-center">
                        128, City Road, London, EC1V 2NX, UNITED KINGDOM
                    </p>
                    <p className="text-[14px] font-normal leading-[16.41px] text-gray-light">
                        Company Number: 16357095
                    </p>
                </div>
            </div>
        </div>
    );
};
export default Footer;