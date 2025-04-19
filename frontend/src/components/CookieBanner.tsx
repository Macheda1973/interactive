import React, { useEffect, useState } from 'react';

const CookieBanner: React.FC = () => {
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    const hasAccepted = localStorage.getItem('cookieAccepted');
    if (!hasAccepted) {
      setIsVisible(true);
    }
  }, []);

  const handleAccept = () => {
    localStorage.setItem('cookieAccepted', 'true');
    setIsVisible(false);
  };

  const handleSettings = () => {
    alert("Please accept cookies");
  };

  if (!isVisible) return null;

  return (
    <div className="fixed bottom-0 w-full bg-gray-100 dark:bg-[#1f1f2e] text-black dark:text-white shadow-md px-6 py-4 z-50">
      <div className="max-w-7xl mx-auto flex flex-col md:flex-row items-center justify-between gap-4">
        <p className="text-sm md:text-base">
          This website uses cookies to ensure you get the best experience on our website.
        </p>
        <div className="flex gap-2">
          <button
            onClick={handleSettings}
            className="text-sm px-4 py-1 border border-gray-400 rounded hover:bg-gray-200 dark:hover:bg-gray-700"
          >
            Change Settings
          </button>
          <button
            onClick={handleAccept}
            className="text-sm px-4 py-1 bg-green-600 text-white rounded hover:bg-green-700"
          >
            Accept Cookies
          </button>
        </div>
      </div>
    </div>
  );
};

export default CookieBanner;
