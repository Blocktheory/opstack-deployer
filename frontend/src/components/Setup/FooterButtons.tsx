import LoaderIcon from "../../assets/loader.png"


function FooterButtons({ onNext, onBack, onReset, currStep }: any) {
    return (
        <div className="flex justify-around w-full  fixed bottom-0 bg-white py-3">
            <button
                onClick={onReset}
                className=" flex space-x-1 mx-2 rounded-full border  text-black  font-semibold py-2 px-4"
            >
                <img src={LoaderIcon} ></img> Reset
            </button>
            <span>
                {currStep != 0 &&
                    <button
                        onClick={onBack}
                        className="mx-2 rounded-full border bg-white  text-black  font-semibold py-2 px-4 "
                    >
                        &larr; Back
                    </button>
                }
                {currStep != 2 &&
                    <button
                        onClick={onNext}
                        className="mx-2 rounded-full border bg-black  text-white  font-semibold py-2 px-4 "
                    >
                        Next &rarr;
                    </button>
                }
                {currStep == 2 &&
                    <button
                        className="mx-2 rounded-full border bg-black hover:bg-white text-white hover:text-black font-semibold py-2 px-4 "
                    >
                        Finish
                    </button>
                }
            </span>
        </div>
    );
};

export default FooterButtons;