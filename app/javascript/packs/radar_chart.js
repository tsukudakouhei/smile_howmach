const createRadarChart = () => {
    const ctx = document.getElementById('myRadarChart');
    if (!ctx) return; // If the element doesn't exist, exit the function

    ctx.getContext('2d');
    new window.Chart(ctx, { // Use window.Chart instead of just Chart
        // ... Radar chart configuration goes here
        type: 'radar',
        data: {
            labels: ['目の表情', '口元の表情', '鼻の位置', '顎の位置', '自然度・バランス'],
            datasets: [{
                label: 'ChatGPTからの分析結果',
                data: window.chartData,
                fill: true,
                backgroundColor: 'rgba(255, 99, 132, 0.2)',
                borderColor: 'rgb(255, 99, 132)',
                pointBackgroundColor: 'rgb(255, 99, 132)',
                pointBorderColor: '#fff',
                pointHoverBackgroundColor: '#fff',
                pointHoverBorderColor: 'rgb(255, 99, 132)'
            }]
        },
        options: {
        scale: {
            min: 0, // Set the minimum value for the scale
            max: 20, // Set the maximum value for the scale
            stepSize: 5, // Set the step size between the ticks
        },
        responsive: true, // Enable responsive settings
        maintainAspectRatio: true // Maintain aspect ratio
        },
        });
};

document.addEventListener('DOMContentLoaded', () => {
    createRadarChart();
});
