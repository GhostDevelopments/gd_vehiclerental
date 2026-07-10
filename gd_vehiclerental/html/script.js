window.addEventListener("message", (event) => {
    const { action, vehicles } = event.data;

    if (action === "open") {
        document.body.classList.add("opacity-100", "pointer-events-auto");
        document.body.classList.remove("opacity-0", "pointer-events-none");
        renderVehicles(vehicles);
    }
});

const renderVehicles = (vehicles) => {
    const container = document.getElementById("vehicle-list");
    container.innerHTML = "";

    vehicles.forEach(veh => {
        const card = document.createElement("div");
        card.className = "item-row group px-8 py-5 flex justify-between items-center cursor-pointer transition-all border-b border-white/[0.02] last:border-0";
        card.onclick = () => rent(veh.model, veh.price);
        card.innerHTML = `
            <div class="flex flex-col">
                <h3 class="text-white/90 font-bold text-lg tracking-wide group-hover:text-white transition-colors uppercase">${veh.label}</h3>
                <span class="text-[10px] text-white/20 uppercase tracking-[0.2em] font-bold mt-0.5">Commercial Rental Vehicle</span>
            </div>
            <div class="flex items-center gap-6">
                <div class="flex flex-col items-end">
                    <span class="text-white/80 font-bold text-xl leading-none">${veh.price.toLocaleString()}</span>
                    <span class="text-[9px] text-white/20 uppercase tracking-widest font-bold mt-1">Full Coverage</span>
                </div>
                <div class="p-2 rounded-lg bg-white/5 group-hover:bg-white text-white/20 group-hover:text-black transition-all">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                    </svg>
                </div>
            </div>
        `;
        container.appendChild(card);
    });
};

const rent = (model, price) => {
    fetch(`https://${GetParentResourceName()}/rentVehicle`, {
        method: "POST",
        body: JSON.stringify({ model, price }),
    });
    closeUI();
};

const closeUI = () => {
    document.body.classList.add("opacity-0", "pointer-events-none");
    document.body.classList.remove("opacity-100", "pointer-events-auto");
    fetch(`https://${GetParentResourceName()}/close`, {
        method: "POST",
        body: JSON.stringify({}),
    });
};

document.addEventListener("keydown", (e) => {
    if (e.key === "Escape") closeUI();
});