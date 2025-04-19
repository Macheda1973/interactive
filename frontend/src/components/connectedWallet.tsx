"use client";
import React, { useState, useRef, useEffect } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faClose } from "@fortawesome/free-solid-svg-icons";
import DefaultAnimation from "./layout/DefaultAnimation";
import ReCAPTCHA from "react-google-recaptcha";

interface ConnectProps {
  isOpen: boolean;
  isStatus: number;
  onClose: () => void;
}

const ConnectedWallet: React.FC<ConnectProps> = ({
  isOpen,
  isStatus,
  onClose,
}) => {
  const connectRef = useRef<HTMLDivElement | null>(null);
  const [isConnectedStatus, setIsConnectedStatus] = useState(0); // 1: login, 2: sign
  const [isForgotMode, setIsForgotMode] = useState(false);

  // Reset Password Mode
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  // Login / Sign Mode
  const [loginEmail, setLoginEmail] = useState("");
  const [loginPassword, setLoginPassword] = useState("");

  useEffect(() => {
    setIsConnectedStatus(isStatus);
  }, [isStatus]);

  const handleToggle = () => {
    setIsConnectedStatus(isConnectedStatus === 1 ? 2 : 1);
    setLoginEmail("");
    setLoginPassword("");
    setEmail("");
    setPassword("");
    setIsForgotMode(false);
  };

  const handleClose = () => {
    setIsForgotMode(false);
    setEmail("");
    setPassword("");
    setLoginEmail("");
    setLoginPassword("");
    onClose();
  };

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (connectRef.current && !connectRef.current.contains(event.target as Node)) {
        handleClose();
      }
    };
    document.addEventListener("mousedown", handleClickOutside);
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, [onClose]);

  const [isVerified, setIsVerified] = useState(false);

  const handleCaptchaChange = (value: string | null) => {
    setIsVerified(!!value);
  };

  return (
    isOpen && (
      <div className="absolute w-full h-[100vh] inset-0 bg-black bg-opacity-50 z-[1000]">
        <div
          ref={connectRef}
          className="absolute flex justify-center items-center top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 px-[25px]"
        >
          <DefaultAnimation>
            <div className="flex flex-col rounded-[15px] flex-wrap w-[280px] sm:w-[490px] h-fit bg-white dark:bg-gray-dark p-[20px] sm:p-[35px] shadow-custom border-[0.6px] border-gray-light dark:border-gray-default">
              <div className="flex flex-col gap-6 w-full">
                <div className="flex w-full relative">
                  <p className="w-full text-[20px] font-bold leading-[23.41px] text-black dark:text-white py-2">
                    {isForgotMode
                      ? "Reset Password"
                      : isConnectedStatus === 1
                        ? "Login"
                        : "Sign Up"}
                  </p>
                  <button onClick={handleClose}>
                    <FontAwesomeIcon
                      icon={faClose}
                      className="text-[18px] font-bold text-black dark:text-white absolute top-0 right-0"
                    />
                  </button>
                </div>

                {!isForgotMode && (
                  <button
                    onClick={handleToggle}
                    className={`flex w-full bg-[#E4E4E4] dark:bg-[#3C3C3C] text-[#757575] dark:text-gray-light rounded-lg`}
                  >
                    <span
                      className={`flex w-full justify-center rounded-lg p-2 px-4 ${isConnectedStatus === 1
                        ? "bg-green-default border-1 border-green-default text-white dark:text-black"
                        : ""
                        }`}
                    >
                      Login
                    </span>
                    <span
                      className={`flex w-full justify-center rounded-lg p-2 px-4 ${isConnectedStatus === 2
                        ? "bg-green-default border-1 border-green-default text-white dark:text-black"
                        : ""
                        }`}
                    >
                      Sign
                    </span>
                  </button>
                )}

                {isForgotMode ? (
                  <>
                    <input
                      type="email"
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      placeholder="Enter new email"
                      className="w-full p-[12px] rounded-lg bg-[#E4E4E4] dark:bg-[#3C3C3C] text-black dark:text-white"
                    />
                    <input
                      type="password"
                      value={password}
                      onChange={(e) => setPassword(e.target.value)}
                      placeholder="Enter new password"
                      className="w-full p-[12px] rounded-lg bg-[#E4E4E4] dark:bg-[#3C3C3C] text-black dark:text-white"
                    />

                    {/* reCAPTCHA */}
                    <div className="flex justify-center">
                      <div className="scale-[0.8] sm:scale-100 origin-center">
                        <ReCAPTCHA
                          sitekey="6LdRXRwrAAAAAEfusbO8lfbWcfmPXOG8_KraHaKd"
                          onChange={handleCaptchaChange}
                        />
                      </div>
                    </div>

                    <div className="flex justify-center gap-3">
                      <button
                        onClick={() => {
                          if (!isVerified) return;
                          alert("Password reset successfully!");
                          setIsForgotMode(false);
                          setEmail("");
                          setPassword("");
                          setIsVerified(false);
                        }}
                        disabled={!isVerified}
                        className={`font-[500] text-[18px] w-[150px] leading-[24px] py-[9px] px-[21px] rounded-full text-white 
          ${isVerified ? "bg-green-default" : "bg-gray-400 cursor-not-allowed"}`}
                      >
                        Submit
                      </button>
                    </div>
                  </>
                ) : (

                  <>
                    <input
                      type="email"
                      value={loginEmail}
                      onChange={(e) => setLoginEmail(e.target.value)}
                      placeholder="Email"
                      className="w-full p-[12px] rounded-lg bg-[#E4E4E4] dark:bg-[#3C3C3C] text-black dark:text-white"
                    />
                    <input
                      type="password"
                      value={loginPassword}
                      onChange={(e) => setLoginPassword(e.target.value)}
                      placeholder="Password"
                      className="w-full p-[12px] rounded-lg bg-[#E4E4E4] dark:bg-[#3C3C3C] text-black dark:text-white"
                    />
                    {isConnectedStatus === 1 && (
                      <button
                        className="text-blue-500 text-sm self-start hover:font-semibold"
                        onClick={() => {
                          setIsForgotMode(true);
                          setLoginEmail("");
                          setLoginPassword("");
                        }}
                      >
                        Forgot password?
                      </button>
                    )}
                    <div className="flex justify-center">
                      <button className="bg-[#EF4444] font-[500] text-[18px] w-[200px] leading-[24px] py-[9px] px-[21px] rounded-full text-white">
                        {isConnectedStatus === 1 ? "Login" : "Sign"}
                      </button>
                    </div>
                  </>
                )}
              </div>
            </div>
          </DefaultAnimation>
        </div>
      </div>
    )
  );
};

export default ConnectedWallet;
