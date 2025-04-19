import { faClose } from '@fortawesome/free-solid-svg-icons/faClose';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import React, { useState } from 'react';

const Footer: React.FC = () => {
    const [showPrivacy, setShowPrivacy] = useState(false);
    const [showCookies, setShowCookies] = useState(false);

    return (
        <div className='w-full bg-white dark:bg-[#16153D] shadow-custom-green px-4 py-2 md:px-16 md:py-4 h-[20vh] md:h-[15vh]'>
            <div className='flex flex-col md:flex-row justify-between items-center space-y-1 relative'>
                <div className='flex flex-col gap-2 w-full items-center md:items-start justify-center'>
                    <p className="text-[14px] font-bold leading-[16.41px] text-white">
                        INTERACTIVE COMPANIES LIMITED
                    </p>
                    <p className="text-[12px] font-normal leading-[16.41px] text-gray-light text-start">
                        128, City Road, London, EC1V 2NX, UNITED KINGDOM
                    </p>
                    <p className="text-[12px] font-normal leading-[16.41px] text-gray-light">
                        Company Number: 16357095
                    </p>
                </div>

                <p className="flex w-full font-semibold justify-center text-[14px] text-center font-[300] leading-[30px] text-gray-light dark:text-white">
                    © 2025 Our Company
                </p>

                <div className='hidden md:flex flex-row w-full'>
                    <div className="flex w-full items-center gap-4 justify-end">
                        <a href="https://www.mastercard.us/en-us.html" target="_blank" rel="noopener noreferrer">
                            <img src="/assets/image/mastercard.png" alt="Mastercard" className="w-[30px] h-[20px]" />
                        </a>
                        <a href="https://stripe.com/" target="_blank" rel="noopener noreferrer">
                            <img src="/assets/image/stripe.png" alt="Stripe" className="w-[30px] h-[20px]" />
                        </a>
                        <a href="https://usa.visa.com/" target="_blank" rel="noopener noreferrer">
                            <img src="/assets/image/visa.png" alt="Visa" className="w-[30px] h-[20px]" />
                        </a>
                    </div>
                    <div className="flex flex-col gap-2 w-full items-center md:items-end justify-end">
                        <button
                            onClick={() => setShowPrivacy(true)}
                            className="text-[14px] font-normal leading-[16.41px] text-gray-light hover:font-bold hover:text-white"
                        >
                            Privacy
                        </button>
                        <button
                            onClick={() => setShowCookies(true)}
                            className="text-[14px] font-normal leading-[16.41px] text-gray-light hover:font-bold hover:text-white"
                        >
                            Cookies
                        </button>
                    </div>
                </div>
            </div>

            {/* Privacy Modal */}
            {showPrivacy && (
                <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
                    <div className="bg-white dark:bg-[#222] p-6 rounded-lg max-w-md w-full min-h-[50%] gap-4 flex flex-col justify-between items-center">
                        <div className='flex flex-col gap-4'>
                            <div className='flex justify-between items-center'>
                                <h2 className="text-2xl font-bold mb-2">Privacy Policy</h2>
                                <button onClick={() => setShowPrivacy(false)}>
                                    <FontAwesomeIcon
                                        icon={faClose}
                                        className="text-[28px] font-extrabold text-black dark:text-white"
                                    />
                                </button>
                            </div>
                            <p className="text-sm text-gray-700 dark:text-gray-300">
                                This is some dummy text about our privacy policy. You can replace this with real content later.
                            </p>
                        </div>

                        <button
                            onClick={() => setShowPrivacy(false)}
                            className="mt-4 bg-green-600 text-white py-2 px-4 rounded w-3/4 hover:bg-green-700"
                        >
                            Close
                        </button>
                    </div>
                </div>
            )}

            {/* Cookies Modal */}
            {showCookies && (
                <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
                    <div className="bg-white dark:bg-[#222] p-6 rounded-lg max-w-md w-full min-h-[50%] gap-4 flex flex-col justify-between items-center">
                        <div className='flex flex-col gap-4'>
                            <div className='flex justify-between items-center'>
                                <h2 className="text-2xl font-bold mb-2">Cookies Information</h2>
                                <button onClick={() => setShowCookies(false)}>
                                    <FontAwesomeIcon
                                        icon={faClose}
                                        className="text-[28px] font-extrabold text-black dark:text-white"
                                    />
                                </button>
                            </div>
                            <p className="text-sm text-gray-700 dark:text-gray-300">
                                This is some dummy text about cookies. You can provide information about your cookie usage here.
                            </p>
                        </div>

                        <button
                            onClick={() => setShowCookies(false)}
                            className="mt-4 bg-green-600 text-white py-2 px-4 rounded w-3/4 hover:bg-green-700"
                        >
                            Close
                        </button>
                    </div>
                </div>
            )}
        </div>
    );
};

export default Footer;
