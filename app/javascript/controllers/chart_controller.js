import { Controller } from "@hotwired/stimulus"
import { AreaSeries, createChart } from 'lightweight-charts';

export default class extends Controller {
    connect() {
        const chartContainer = document.getElementById('chartContainer');
        const buttonsContainer = document.getElementById('buttonsContainer');

        const options = {
            autoSize: true,
            width: chartContainer.clientWidth,
            height: 400,
            layout: {
                background: { type: 'solid', color: '#000000' },
                textColor: '#A3A6AF',
                fontFamily: "'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif",
            },
            grid: {
                vertLines: { visible: false },
                horzLines: { color: 'rgba(42, 46, 57, 0.3)', style: 3 },
            },
            crosshair: {
                mode: 1,
                vertLine: { width: 1, color: '#758696', style: 3, labelBackgroundColor: '#2B2B43' },
                horzLine: { width: 1, color: '#758696', style: 3, labelBackgroundColor: '#2962FF' },
            },
            timeScale: {
                borderColor: 'transparent',
                timeVisible: true,
                fixLeftEdge: true,
                fixRightEdge: true,
                rightOffset: 0,
            },
            rightPriceScale: {
                borderColor: 'transparent',
            },
        }

        const data = JSON.parse(this.element.dataset.chartSnapshotsValue)
        const dayData = JSON.parse(this.element.dataset.chartSnapshotsDayValue)
        const weekData = JSON.parse(this.element.dataset.chartSnapshotsWeekValue)
        const monthData = JSON.parse(this.element.dataset.chartSnapshotsMonthValue)
        const yearData = JSON.parse(this.element.dataset.chartSnapshotsYearValue)

        const seriesesData = new Map([
            ['1D', dayData],
            ['1W', weekData],
            ['1M', monthData],
            ['1Y', yearData],
        ]);

        const chart = createChart(chartContainer, options);

        const areaSeries = chart.addSeries(AreaSeries, {
            lineColor: '#2962FF',
            topColor: 'rgba(41, 98, 255, 0.4)',
            bottomColor: 'rgba(41, 98, 255, 0.0)',
            lineWidth: 2,
            priceLineColor: '#2962FF',
            priceLineStyle: 3,
            crosshairMarkerVisible: true,
            crosshairMarkerRadius: 4,
            crosshairMarkerBorderColor: '#ffffff',
            crosshairMarkerBackgroundColor: '#2962FF',
        });

        let currentInterval = '1M';

        const setChartInterval = (interval) => {
            currentInterval = interval;
            areaSeries.setData(seriesesData.get(interval));
            chart.timeScale().fitContent();
            renderButtons();
        }

        const intervals = ['1D', '1W', '1M', '1Y'];

        const renderButtons = () => {
            buttonsContainer.innerHTML = '';

            intervals.forEach(interval => {
                const button = document.createElement('button');
                button.innerText = interval;

                if (interval === currentInterval) {
                    button.className = "px-4 py-2 bg-[#2B2B2B] text-white rounded-lg font-medium text-sm transition";
                } else {
                    button.className = "px-4 py-2 bg-transparent text-[#A3A6AF] hover:text-white rounded-lg font-medium text-sm transition cursor-pointer";
                }

                button.addEventListener('click', () => setChartInterval(interval));
                buttonsContainer.appendChild(button);
            });
        }

        setChartInterval('1M');
    }
}