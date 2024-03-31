import { NextRequest, NextResponse } from "next/server";

export async function POST(request: NextRequest) {
	try {
		const req = await request.json();
		const { rcr_percent, r_percent, buyback_percent } = req;
		console.log(rcr_percent, r_percent, buyback_percent);
		return NextResponse.json({message: "success"}, {status: 200});
	} catch (err) {
		console.error(err);
		return NextResponse.json({ error: (err as Error).message }, { status: 400 });

	}
}
