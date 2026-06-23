import { Controller } from "@hotwired/stimulus"
import { AreaSeries, BarSeries, BaselineSeries, createChart } from 'lightweight-charts';

export default class extends Controller {

    connect() {
        console.log("Chart controller connected");
        // Initialize the chart

        const options = {
            autoSize: true,
            width: this.element.clientWidth,
            height: 400,
            layout: {
                backgroundColor: '#ffffff',
                textColor: '#232323',
            }

        }
        const chart = createChart(this.element, options);
        const areaSeries = chart.addSeries(AreaSeries, { lineColor: '#2962FF', topColor: '#2962FF',
            bottomColor: 'rgba(41, 98, 255, 0.28)' });
        const data = JSON.parse(this.element.dataset.chartSnapshotsValue)
        areaSeries.setData(data);
        chart.timeScale().fitContent();



    };





}
