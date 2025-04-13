"use client"; // Add this line
import React, {useState} from 'react';
import Connect from '@/components/connect';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faChevronLeft, faChevronRight } from '@fortawesome/free-solid-svg-icons';

export default function Home() {
    const [isConnectOpen, setConnectOpen] = useState<boolean>(false);
    const closeConnect = () => setConnectOpen(false);

    const sliders = [
      {tittle: 'Home First', color: "bg-[#002345]"},
      {tittle: 'Home Second', color: "bg-[#456700]"},
      {tittle: 'Home Third', color: "bg-[#456278]"},
      {tittle: 'Home Fourth', color: "bg-[#786278]"}
    ];
    
      const [currentIndex, setCurrentIndex] = useState(0);
    
      const nextImage = () => {
        setCurrentIndex((prevIndex) => (prevIndex + 1) % sliders.length);
      };
    
      const prevImage = () => {
        setCurrentIndex((prevIndex) => (prevIndex - 1 + sliders.length) % sliders.length);
      };
  return (
    <div className="container mx-auto main-container overflow-x-hidden flex relative">
      {sliders.map((slider, index) => 
        <div key={index} className={`min-w-full h-full ${slider.color} transition-all duration-300 flex items-center justify-center`} style={{ transform: `translateX(${(-currentIndex) * 100}%)`}}>{slider.tittle}</div>
      )}
      {/* <div className='min-w-full h-full bg-[#0000ff] transition-all duration-300 flex items-center justify-center' style={{ transform: `translateX(${(-currentIndex) * 100}%)`}}></div>
      <div className='min-w-full h-full bg-[#00ff00] transition-all duration-300' style={{ transform: `translateX(${(-currentIndex) * 100}%)`}}></div>
      <div className='min-w-full h-full bg-[#ff0000] transition-all duration-300' style={{ transform: `translateX(${(-currentIndex) * 100}%)`}}></div> */}
      <div className="absolute top-1/2 flex w-full  justify-between">
        <button
          onClick={prevImage}
          className="flex items-center w-8 h-8 justify-center rounded-full p-2 bg-gray-800 text-white hover:bg-gray-700"
        >
          <FontAwesomeIcon icon={faChevronLeft} />
        </button>
        <button
          onClick={nextImage}
          className="flex items-center w-8 h-8 justify-center rounded-full p-2 bg-gray-800 text-white hover:bg-gray-700"
        >
          <FontAwesomeIcon icon={faChevronRight} />
        </button>
      </div>
      <div className="absolute bottom-1 left-1/2 -translate-x-1/2  flex justify-center">
        {sliders.map((_, index) => (
          <button
            key={index}
            onClick={() => setCurrentIndex(index)}
            className={`w-3 h-3 mx-1 rounded-full ${currentIndex === index ? 'bg-blue-600' : 'bg-gray-300'}`}
          />
        ))}
      </div>
      <Connect  isOpen={isConnectOpen} onClose={closeConnect}></Connect>
    </div>
  );
}
