import { useState } from "react";
import show from "../../assets/show_icon.svg";
import hide from "../../assets/hide_icon.svg";

type TInputType = {
  htmlFor: string;
  name: string;
  spanName: string;
  inputValue: string | number;
  inputId: string;
  inputType: string;
  isPrivate?: boolean;
};

export const Input = (props: TInputType) => {
  const { htmlFor, name, spanName, inputValue, inputId, inputType, isPrivate } =
    props;
  const [showText, setShowText] = useState(false);

  return (
    <>
      <div className="flex justify-between items-center">
        <label
          htmlFor={htmlFor}
          className="font-sans block text-sm font-medium text-[#101521CC] mb-1"
          onClick={() => {
            setShowText(!showText);
          }}
        >
          <span className="font-semibold">{spanName} </span> {name}
        </label>
      </div>
      {isPrivate ? (
        <div className="relative">
          <input
            disabled
            value={showText ? inputValue : "*******************************"}
            type={inputType}
            id={inputId}
            className="bg-gray-200 text-xs w-full rounded  border-grey-300 border-2  p-4 pr-10 relative"
            placeholder={inputId}
          />
          <button
            onClick={() => {
              setShowText(!showText);
            }}
          >
            <img
              src={showText ? hide : show}
              alt="hide/show"
              className="absolute right-2 top-1/2 -translate-y-1/2 w-5 transition-all duration-200 ml-3 mt-[2px]"
            />
          </button>
        </div>
      ) : (
        <input
          disabled
          value={inputValue}
          type={inputType}
          id={inputId}
          className="bg-gray-200 text-xs w-full rounded  border-grey-300 border-2  p-4 pr-6"
          placeholder={inputId}
        />
      )}
    </>
  );
};
